import express from 'express';
import colors from 'colors';

import { NotFound, BadRequest } from 'http-errors';

import schemas from '../schemas/index';
import vehicleSchema from '../schemas/vehicle';
import userSchema from '../schemas/user';
import cache from '../cache';

const Vehicle = vehicleSchema.Vehicle;
const CurrentLocation = schemas.CurrentLocation;
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
		console.error(colors.red('Failed to toggle status'), e);
		throw new Error(e.message);
	}
};

const locationUpdate = async (vehicleId: string, latitude: number, longitude: number): Promise<void> => {
	try {
		await CurrentLocation.create({ vehicleId, latitude, longitude });
	} catch (e: any) {
		console.error(colors.red('Failed to update location'), e);
		throw new Error(e.message)
	}
};

interface vehicleLocation {
	vehicleId: string;
	latitude: number;
	longitude: number;
}

const getVehiclesLocation = async (): Promise<vehicleLocation[]> => {
	try {
		const cachedData = await cache.getAllData();
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
		console.error(colors.red('Failed to get vehicles location'), e);
		throw e;
	}
};

const getVehicles = async (): Promise<object[]> => {
	try {
		const vehicles = await Vehicle.find({}).select('name vehicleRegistrationNumber status type');
		if (vehicles.length === 0) return [];

		return vehicles.map((vehicle) => {
			return {
				vehicleRegistrationNumber: vehicle.vehicleRegistrationNumber,
				name: vehicle.name,
				status: vehicle.status,
				type: vehicle.type,
			};
		});
	} catch (e: any) {
		console.error(colors.red('Failed to get vehicles data'), e);
		throw e;
	}
};

const getDrivers = async (): Promise<object[]> => {
	try {
		const driver = await User.find({ groups: 'driver' }).select('name picture phoneNumber');
		if (driver.length === 0) return [];

		return driver.map((driver) => {
			return {
				name: driver.name,
				picture: driver.picture,
				phoneNumber: driver.phoneNumber,
			};
		});
	} catch (e: any) {
		console.error(colors.red('Failed to get drivers data'), e);
		throw e;
	}
};

const api = { journeyToggle, locationUpdate, getVehiclesLocation, getVehicles, getDrivers };
export default api;
