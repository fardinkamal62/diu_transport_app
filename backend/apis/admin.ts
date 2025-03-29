import colors from 'colors';
import * as jwt from 'jsonwebtoken';
import { NotFound, Unauthorized, BadRequest, InternalServerError } from 'http-errors';
import express from 'express';

import utils from '../utils';
import userSchema from '../schemas/user';
import vehicleSchema from '../schemas/vehicle';


const login = async (req: express.Request): Promise<object> => {
	const query = {
		'username': req.body.username as string,
	};

	try {
		const user = await userSchema.User.findOne(query);

		if (!user) {
			throw new NotFound('User not found');
		}

		if (!user.groups.includes('admin')) {
			throw new Unauthorized('User is not an admin');
		}

		const isPasswordValid = await utils.comparePassword(req.body.password, user.password);

		if (!isPasswordValid) {
			throw new Unauthorized('Invalid password');
		}

		const secret: string = process.env.JWT_SECRET as string;

		if (secret == null) {
			throw new Error('Secret not found');
		}

		const sign: string = jwt.sign({ username: user.phoneNumber, role: 'admin' }, secret, { expiresIn: '1d' });

		if (!sign) {
			throw new InternalServerError('Failed to generate token');
		}

		return { token: sign };
	} catch (e) {
		console.error(colors.red('Failed to login'), e);
		throw e;
	}
};

const addVehicle = async (req: express.Request): Promise<object> => {
	const name = req.body.name as string;
	const type = req.body.type as string;
	const vehicleRegistrationNumber = req.body.vehicleRegistrationNumber as string;

	if (!name || !type || !vehicleRegistrationNumber) {
		throw new BadRequest('Name, type and vehicle registration number are required');
	}

	const vehicle = new vehicleSchema.Vehicle({
		name,
		type,
		vehicleRegistrationNumber,
	});

	try {
		await vehicle.save();
		return vehicle;
	} catch (e) {
		console.error(colors.red('Failed to add vehicle'), e);
		throw new InternalServerError('Failed to add vehicle');
	}
};

const addDriver = async (req: express.Request): Promise<object> => {
	const name = req.body.name as string;
	const phoneNumber = req.body.phoneNumber as string;
	const password = req.body.password as string;

	if (!name || !phoneNumber) {
		throw new BadRequest('Name, phone number and vehicle ID are required');
	}

	const driver = new userSchema.User({
		name,
		phoneNumber,
		password: password,
		groups: ['driver'],
	});

	try {
		await driver.save();
		return driver;
	} catch (e) {
		console.error(colors.red('Failed to add driver'), e);
		throw new InternalServerError('Failed to add driver');
	}
};

const adminApi = {
	login,
	addVehicle,
	addDriver,
};

export default adminApi;
