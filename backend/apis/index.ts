import express from 'express';
import colors from 'colors';

import { NotFound, BadRequest } from 'http-errors';

import schemas from '../schemas/index';
const Vehicle = schemas.Vehicle;

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
}

const api = { journeyToggle };
export default api;
