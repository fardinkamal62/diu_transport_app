import * as jwt from 'jsonwebtoken';
import { NotFound, Unauthorized, BadRequest, InternalServerError } from 'http-errors';
import express from 'express';
import moment from 'moment-timezone';

import utils from '../utils';
import userSchema from '../schemas/user';
import vehicleSchema from '../schemas/vehicle';

import logger from '../utils/logger';

const login = async (req: express.Request): Promise<object> => {
	const query: any = {};

	if (req.body.username) {
		query.username = req.body.username as string;
	}

	if (req.body.email) {
		query.email = req.body.email as string;
	}

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
		logger.error(('Failed to login'), e);
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
		logger.error(('Failed to add vehicle'), e);
		throw new InternalServerError('Failed to add vehicle');
	}
};

const addDriver = async (req: express.Request): Promise<object> => {
	const name = req.body.name as string;
	const phoneNumber = req.body.phoneNumber as string;
	const password = req.body.password as string;

	if (!name || !phoneNumber || !password) {
		throw new BadRequest('Name, phone number and password are required');
	}

	const driver = new userSchema.User({
		name,
		phoneNumber,
		password: await utils.hashPassword(password),
		groups: ['driver'],
	});

	try {
		await driver.save();
		return driver;
	} catch (e) {
		logger.error(('Failed to add driver'), e);
		throw new InternalServerError('Failed to add driver');
	}
};

const updateVehicleData = async (req: express.Request): Promise<object> => {
	const vehicleId = req.params.id as string;
	const vehicle = await vehicleSchema.Vehicle.findById(vehicleId);

	if (!vehicle) {
		throw new NotFound('Vehicle not found');
	}

	const name = req.body.name as string;
	const type = req.body.type as string;
	const vehicleRegistrationNumber = req.body.vehicleRegistrationNumber as string;
	const status = req.body.status as string;

	if (name) {
		vehicle.name = name;
	}

	if (type === 'bus' || type === 'microbus') {
		vehicle.type = type;
	} else {
		throw new BadRequest('Invalid vehicle type');
	}

	if (vehicleRegistrationNumber) {
		vehicle.vehicleRegistrationNumber = vehicleRegistrationNumber;
	}

	if (status === 'active' || status === 'inactive') {
		vehicle.status = status;
	} else {
		throw new BadRequest('Invalid vehicle status');
	}

	try {
		await vehicle.save();
		return vehicle;
	} catch (e) {
		logger.error(('Failed to update vehicle'), e);
		throw new InternalServerError('Failed to update vehicle');
	}
};

const updateDriverData = async (req: express.Request): Promise<object> => {
	const driverId = req.params.id as string;
	const driver = await userSchema.User.findById(driverId);

	if (!driver) {
		throw new NotFound('Driver not found');
	}

	const name = req.body.name as string;
	const phoneNumber = req.body.phoneNumber as string;
	const password = req.body.password as string;

	if (name) {
		driver.name = name;
	}

	if (phoneNumber) {
		driver.phoneNumber = phoneNumber;
	}

	if (password) {
		driver.password = await utils.hashPassword(password);
	}

	try {
		await driver.save();
		return driver;
	} catch (e) {
		logger.error(('Failed to update driver'), e);
		throw new InternalServerError('Failed to update driver');
	}
};

const deleteVehicle = async (req: express.Request): Promise<object> => {
	const vehicleId = req.params.id as string;
	const vehicle = await vehicleSchema.Vehicle.findById(vehicleId);

	if (!vehicle) {
		throw new NotFound('Vehicle not found');
	}

	try {
		vehicle.deletedAt = moment().tz('Asia/Dhaka').format();
		await vehicle.save();
		return { message: 'Vehicle deleted successfully' };
	} catch (e) {
		logger.error(('Failed to delete vehicle'), e);
		throw new InternalServerError('Failed to delete vehicle');
	}
};

const deleteDriver = async (req: express.Request): Promise<object> => {
	const driverId = req.params.id as string;
	const driver = await userSchema.User.findById(driverId);

	if (!driver) {
		throw new NotFound('Driver not found');
	}

	try {
		driver.deletedAt = moment().tz('Asia/Dhaka').format();
		await driver.save();
		return { message: 'Driver deleted successfully' };
	} catch (e) {
		logger.error(('Failed to delete driver'), e);
		throw new InternalServerError('Failed to delete driver');
	}
};

const adminApi = {
	login,
	addVehicle,
	addDriver,
	updateVehicleData,
	updateDriverData,
	deleteVehicle,
	deleteDriver,
};

export default adminApi;

