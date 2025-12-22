import express from 'express';
import { BadRequest, InternalServerError } from 'http-errors';

import reservationSchema from '../../schemas/reservation';
import logger from '../../utils/logger';
import vehicleSchema from '../../schemas/vehicle';
import scheduleSchema from '../../schemas/schedule';

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
	const page = parseInt(req.query.page as string, 10) || 1; // Default to page 1
	const limit = parseInt(req.query.limit as string, 10) || 10; // Default to 10 items per page

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
		const totalReservations = await reservationSchema.VehicleReservation.countDocuments(query);
		const reservations = await reservationSchema.VehicleReservation.find(query)
			.sort({ time: -1 })
			.skip((page - 1) * limit)
			.limit(limit);

		const enrichedReservations = [];
		for (const reservation of reservations) {
			const reservationObj = reservation.toObject(); // Convert to plain object
			if (reservation.vehicleId) {
				const vehicle = await vehicleSchema.Vehicle.findById(reservation.vehicleId);
				if (vehicle) {
					reservationObj.vehicle = {
						name: vehicle.name,
						registrationNumber: vehicle.vehicleRegistrationNumber,
						type: vehicle.type,
					};
				} else {
					reservationObj.vehicle = null;
				}
			}

			if (reservation.scheduleId) {
				const schedule = await scheduleSchema.findById(reservation.scheduleId);
				if (schedule) {
					schedule.dispatches.forEach((dispatch) => {
						if (dispatch.vehicleId && dispatch.vehicleId.equals(reservation.vehicleId)) {
							reservationObj.schedule = {
								dispatchTime: dispatch.dispatchTime,
								returnTime: dispatch.returnTime,
								pickupTime: dispatch.pickupTime,
							};
						}
					});
				}
			}
			enrichedReservations.push(reservationObj);
		}

		return {
			total: totalReservations,
			page,
			limit,
			reservations: enrichedReservations,
		};
	} catch (e) {
		logger.error(('Failed to get reservations'), e);
		throw new InternalServerError('Failed to get reservations');
	}
};

const getReservationSettings = async(req: express.Request): Promise<object> => {
	try {
		const settingsSchema = await import('../../schemas/settings');
		const { getReservationWindowMessage } = await import('../../utils/reservationValidator');
		
		const settings = await settingsSchema.default.getSettings();
		const now = new Date();
		const currentDayOfWeek = now.getDay();
		
		// Get current day settings
		const daySettings = settings.reservationWindows.get(currentDayOfWeek.toString());
		const message = await getReservationWindowMessage();
		
		// Build response with all weekly settings
		const weeklyWindows: any = {};
		const dayNames = ['Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'];
		
		for (let i = 0; i < 7; i++) {
			const daySetting = settings.reservationWindows.get(i.toString());
			weeklyWindows[dayNames[i]] = {
				enabled: daySetting?.enabled || false,
				windows: daySetting?.windows || []
			};
		}
		
		return {
			reservationEnabled: settings.reservationEnabled,
			maxAdvanceBookingDays: settings.maxAdvanceBookingDays,
			currentDay: dayNames[currentDayOfWeek],
			currentDayEnabled: daySettings?.enabled || false,
			currentDayWindows: daySettings?.windows || [],
			message,
			weeklyWindows
		};
	} catch (e) {
		logger.error('Failed to get reservation settings', e);
		throw new InternalServerError('Failed to get reservation settings');
	}
};

const userApi = { addReservation, getReservations, getReservationSettings }
export default userApi;
