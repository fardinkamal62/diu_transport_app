import express from 'express';

import { NotFound, Unauthorized, InternalServerError } from 'http-errors';

import userSchema from '../../schemas/user';
import vehicleSchema from '../../schemas/vehicle';
import allocationSchema from '../../schemas/allocation';


import logger from '../../utils/logger';
import utils from '../../utils';
import * as jwt from 'jsonwebtoken';

const User = userSchema.User;

const login = async (req: express.Request): Promise<object> => {
	const query: any = {
		groups: ['driver'],
	};

	if (req.body.phoneNumber) {
		query.phoneNumber = req.body.phoneNumber as string;
	}

	try {
		const user = await User.findOne(query);

		if (!user) {
			throw new NotFound('Driver not found');
		}

		const isPasswordValid = await utils.comparePassword(req.body.password, user.password);

		if (!isPasswordValid) {
			throw new Unauthorized('Invalid password');
		}

		const secret: string = process.env.JWT_SECRET as string;

		if (secret == null) {
			throw new Error('Secret not found');
		}

		const sign: string = jwt.sign({ username: user.phoneNumber, role: 'driver' }, secret, { expiresIn: '30d' });

		if (!sign) {
			throw new InternalServerError('Failed to generate token');
		}

		return { token: sign, driverDetails: { _id: user._id, name: user.name, phoneNumber: user.phoneNumber, preferredVehicle: user.preferredVehicle } };
	} catch (e) {
		logger.error(('Failed to login'), e);
		throw e;
	}
};

const getAllocation = async (req: express.Request): Promise<object> => {
	const driverId = req.query?.driverId as string;

	if (!driverId) {
		const allocation = await allocationSchema.find({
			createdAt: {
				$gte: new Date(new Date().setHours(0, 0, 0, 0)), // Start of the day
				$lt: new Date(new Date().setHours(23, 59, 59, 999)), // End of the day
			}
		})

		return allocation
	}

	try {
		const driver = await User.findById(driverId);
		if (!driver) {
			throw new NotFound('Driver not found');
		}

		if (!driver.groups.includes('driver')) {
			throw new Unauthorized('User is not a driver');
		}

		const allocation = await allocationSchema.findOne({
			driverId: driver._id,
			createdAt: {
				$gte: new Date(new Date().setHours(0, 0, 0, 0)), // Start of the day
				$lt: new Date(new Date().setHours(23, 59, 59, 999)), // End of the day
			}
		})

		if (!allocation) {
			throw new NotFound('No allocation found for today');
		}
		const vehicle = await vehicleSchema.Vehicle.findById(allocation.vehicleId);
		if (!vehicle) {
			throw new NotFound('Vehicle not found');
		}

		return {
			allocation: {
				_id: allocation._id,
				vehicleId: allocation.vehicleId,
				vehicleRegistrationNumber: vehicle.vehicleRegistrationNumber,
				vehicleName: vehicle.name,
				vehicleType: vehicle.type,
			}
		}
	} catch (e) {
		logger.error('Failed to get driver allocation', e);
		throw new NotFound('Driver not found');
	}
};

const driverApi = {
	login,
	getAllocation,
}

export default driverApi;
