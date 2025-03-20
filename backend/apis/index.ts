import express from 'express';
import colors from 'colors';

import { NotFound, BadRequest } from 'http-errors';

import schemas from '../schemas/index';
import cache from '../cache';

const Vehicle = schemas.Vehicle;
const CurrentLocation = schemas.CurrentLocation;

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

const getVehiclesLocation = async (): Promise<object> => {
	try {
		const cachedData = await cache.getAllData();
		return cachedData.map((data: any) => data.value);
	} catch (e: any) {
		console.error(colors.red('Failed to get vehicles location'), e);
		throw new Error(e.message);
	}
};

const api = { journeyToggle, locationUpdate, getVehiclesLocation };
export default api;
