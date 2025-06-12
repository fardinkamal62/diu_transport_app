import express from 'express';

import { NotFound, BadRequest } from 'http-errors';

import vehicleSchema from '../../schemas/vehicle';
import userSchema from '../../schemas/user';
import scheduleSchema from '../../schemas/schedule';
import reservationSchema from '../../schemas/reservation';

import cache from '../../db/redis_db';

import logger from '../../utils/logger';

const Vehicle = vehicleSchema.Vehicle;
const User = userSchema.User;

const journeyToggle = async (req: express.Request): Promise<object> => {
	try {
		const vehicleId = req.body.vehicleId as string;

		if (vehicleId == null) {
			throw new BadRequest('Vehicle ID is required');
		}

		const vehicle = await Vehicle.findOne({ _id: vehicleId });

		if (vehicle == null) {
			throw new NotFound('Vehicle not found');
		}

		await Vehicle.updateOne({ _id: vehicleId }, { $set: { enRoute: !vehicle.enRoute } });

		return {
			message: 'Vehicle status updated',
		}
	} catch (e: any) {
		logger.error(('Failed to toggle status'), e);
		throw new Error(e.message);
	}
};

interface vehicleLocation {
	vehicleId: string;
	latitude: number;
	longitude: number;
}

const getVehiclesLocation = async (): Promise<vehicleLocation[]> => {
	try {
		const cachedData = await cache.getAllData(cache.getcoOrdinateDatabaseClient(), 'vehicle');
		if (cachedData.length === 0) return [];

		return cachedData.map((data) => {
			const value = data.value;
			return {
				vehicleId: value.vehicleId,
				latitude: Number(value.latitude),
				longitude: Number(value.longitude)
			};
		});
	} catch (e: any) {
		logger.error(('Failed to get vehicles location'), e);
		throw e;
	}
};

const getVehicles = async (): Promise<object[]> => {
	try {
		const vehicles = await Vehicle.find({}).select('name vehicleRegistrationNumber status type capacity reservedSeats');
		if (vehicles.length === 0) return [];

		return vehicles.map((vehicle) => {
			return {
				id: vehicle._id,
				vehicleRegistrationNumber: vehicle.vehicleRegistrationNumber,
				name: vehicle.name,
				status: vehicle.status,
				type: vehicle.type,
				capacity: vehicle.capacity,
				reservedSeats: vehicle.reservedSeats,
			};
		});
	} catch (e: any) {
		logger.error(('Failed to get vehicles data'), e);
		throw e;
	}
};

const getDrivers = async (): Promise<object[]> => {
	try {
		const driver = await User.find({ groups: 'driver' }).select('name picture phoneNumber status preferredVehicle');
		if (driver.length === 0) return [];

		return driver.map((driver) => {
			return {
				id: driver._id,
				name: driver.name,
				picture: driver.picture,
				phoneNumber: driver.phoneNumber,
				status: driver.status,
				preferredVehicle: driver.preferredVehicle,
			};
		});
	} catch (e: any) {
		logger.error(('Failed to get drivers data'), e);
		throw e;
	}
};


/**
 * @function manualReservation
 * @description This function is used to manually reserve a vehicle for a user.
 * Sometimes the user may not be able to reserve a vehicle through the app or they want to ride a different vehicle
 * The vehicle's driver can manually reserve seat for that person.
 * @param req
 * @returns {Promise<object>} Returns a promise that resolves to an object containing the reservation details.
 */
const manualReservation = async (req: express.Request): Promise<object> => {
	const vehicleId = req.body.vehicleId as string;
	const registrationCode = req.body.registrationCode as string;
	const scheduleId = req.body.scheduleId as string;
	const location = req.body.location as string;
	const userType = req.body.userType as string;

	if (!vehicleId || !registrationCode || !scheduleId) {
		throw new BadRequest('Vehicle ID, User ID and Schedule ID are required');
	}

	try {
		const vehicle = await Vehicle.findById(vehicleId);
		if (!vehicle) {
			throw new NotFound('Vehicle not found');
		}

		const user = await User.findById(registrationCode);
		if (!user) {
			throw new NotFound('User not found');
		}

		const schedule = await scheduleSchema.findById(scheduleId);
		if (!schedule) {
			throw new NotFound('Schedule not found');
		}

		await reservationSchema.VehicleReservation.create({
			registrationCode,
			time: schedule.campusReturnTime,
			location,
			userType,
			vehicleId: vehicle._id,
			status: 'onboard',
			message: 'Manually reserved by driver',
		});

		return { message: 'Reservation successful', vehicleId, registrationCode };
	} catch (error: any) {
		logger.error('Failed to manually reserve vehicle', error);
		throw new Error(error.message);
	}
};

const api = { journeyToggle, getVehiclesLocation, getVehicles, getDrivers, manualReservation };
export default api;
