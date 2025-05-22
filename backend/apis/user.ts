import express from 'express';
import { BadRequest, InternalServerError } from 'http-errors';

import reservationSchema from '../schemas/reservation';
import logger from '../utils/logger';

const addReservation = async(req: express.Request): Promise<object> => {
	const registrationCode = req.body.registrationCode as string;
	const timeStr = req.body.time as string;

	const [hours, minutes] = timeStr.split(':').map(Number);
	const now = new Date();
	const reservationTime = new Date(
		now.getFullYear(),
		now.getMonth(),
		now.getDate(),
		hours,
		minutes,
		0,
		0
	);

	// Return if entry already exists
	const existingReservation = await reservationSchema.VehicleReservation.findOne({ registrationCode, time: reservationTime });
	if (existingReservation) {
		throw new BadRequest('Reservation already exists');
	}

	const oneHourLater = new Date(now.getTime() + 60 * 60 * 1000);
	if (reservationTime > oneHourLater) {
		throw new BadRequest('Reservation time must be within one hour');
	}

	const reservation = new reservationSchema.VehicleReservation({
		registrationCode,
		time: reservationTime,
	})

	try {
		await reservation.save();
		return reservation;
	} catch (e) {
		logger.error(('Failed to add reservation'), e);
		throw new InternalServerError('Failed to add reservation');
	}
};

const getReservations = async(req: express.Request): Promise<object> => {
	const registrationCode = req.body.registrationCode as string;
	const timeStr = req.body.time as string | undefined;

	let query: any = { registrationCode };

	if (timeStr && timeStr !== '') {
		const [hours, minutes] = timeStr.split(':').map(Number);
		const now = new Date();
		const reservationTime = new Date(
			now.getFullYear(),
			now.getMonth(),
			now.getDate(),
			hours,
			minutes,
			0,
			0
		);
		query.time = reservationTime;
	}

	try {
		const reservations = await reservationSchema.VehicleReservation.find(query);
		return reservations;
	} catch (e) {
		logger.error(('Failed to get reservations'), e);
		throw new InternalServerError('Failed to get reservations');
	}
};

const userApi = { addReservation, getReservations }
export default userApi;
