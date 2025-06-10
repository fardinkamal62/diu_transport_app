import express from 'express';
import { BadRequest, InternalServerError } from 'http-errors';

import reservationSchema from '../../schemas/reservation';
import logger from '../../utils/logger';

const addReservation = async(req: express.Request): Promise<object> => {
	const registrationCode = req.body.registrationCode as string;
	const timeStr = req.body.time as string;
	const location = req.body.location as string;
	const userType = req.body.userType as string;

	const now = new Date();
	const reservationTime = new Date(timeStr);

	if (reservationTime < now) {
		throw new BadRequest('Cannot make reservations in the past');
	}

	// Return if entry already exists
	const existingReservation = await reservationSchema.VehicleReservation.findOne({ registrationCode, time: reservationTime });
	if (existingReservation) {
		throw new BadRequest('Reservation already exists');
	}

	const hoursLater = new Date(now.getTime() + 24 * 60 * 60 * 1000);
	if (reservationTime > hoursLater) {
		throw new BadRequest('Reservation time must be within 24 hours');
	}

	const reservation = new reservationSchema.VehicleReservation({
		registrationCode,
		time: reservationTime,
		location,
		userType,
		status: 'scheduled',
	})

	try {
		await reservation.save();
		return reservation;
	} catch (e) {
		logger.error('Failed to add reservation', e);
		throw new InternalServerError('Failed to add reservation');
	}
};

const getReservations = async(req: express.Request): Promise<object> => {
	const registrationCode = req.query.registrationCode as string;
	const timeStr = req.query.time as string | undefined;

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
