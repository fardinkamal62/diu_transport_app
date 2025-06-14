import express from 'express';

import { NotFound, Unauthorized, InternalServerError, BadRequest } from 'http-errors';

import userSchema from '../../schemas/user';
import vehicleSchema from '../../schemas/vehicle';
import allocationSchema from '../../schemas/allocation';
import reservationSchema from '../../schemas/reservation';


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

const journeyToggle = async (req: express.Request): Promise<object> => {
	try {
		const vehicleId = req.body.vehicleId as string;

		if (vehicleId == null) {
			throw new BadRequest('Vehicle ID is required');
		}

		const vehicle = await vehicleSchema.Vehicle.findOne({ _id: vehicleId });

		if (vehicle == null) {
			throw new NotFound('Vehicle not found');
		}

		if (vehicle.enRoute === false) {
			await reservationSchema.VehicleReservation.updateMany({
				vehicleId: vehicle._id,
			}, { $set: { status: 'onboard' } });
		} else {
			await reservationSchema.VehicleReservation.updateMany({
				vehicleId: vehicle._id,
			}, { $set: { status: 'completed' } });
		}

		await vehicleSchema.Vehicle.updateOne({ _id: vehicleId }, { $set: { enRoute: !vehicle.enRoute } });

		return {
			message: 'Vehicle status updated',
		}
	} catch (e: any) {
		logger.error(('Failed to toggle status'), e);
		throw new Error(e.message);
	}
};

const driverApi = {
	login,
	getAllocation,
	journeyToggle,
}

export default driverApi;
