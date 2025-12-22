import express from 'express';

import { NotFound, Unauthorized, InternalServerError, BadRequest } from 'http-errors';

import userSchema from '../../schemas/user';
import scheduleSchema from '../../schemas/schedule';
import tripSchema from '../../schemas/trip';
import reservationSchema from '../../schemas/reservation';
import vehicleAllocationSchema from '../../schemas/allocation';
import vehicleSchema from '../../schemas/vehicle';

import logger from '../../utils/logger';
import utils from '../../utils';
import * as jwt from 'jsonwebtoken';

const User = userSchema.User;

const login = async (req: express.Request): Promise<object> => {
	const query: any = {
		groups: ['lineman'],
	};

	if (req.body.phoneNumber) {
		query.phoneNumber = req.body.phoneNumber as string;
	}

	try {
		const user = await User.findOne(query);

		if (!user) {
			throw new NotFound('Lineman not found');
		}

		const isPasswordValid = await utils.comparePassword(req.body.password, user.password);

		if (!isPasswordValid) {
			throw new Unauthorized('Invalid password');
		}

		const secret: string = process.env.JWT_SECRET as string;

		if (secret == null) {
			throw new Error('Secret not found');
		}

		const sign: string = jwt.sign({ username: user.phoneNumber, role: 'lineman' }, secret, { expiresIn: '30d' });

		if (!sign) {
			throw new InternalServerError('Failed to generate token');
		}

		return { token: sign, linemanDetails: { _id: user._id, name: user.name, phoneNumber: user.phoneNumber } };
	} catch (e) {
		logger.error(('Failed to login'), e);
		throw e;
	}
};

const getSchedules = async (req: express.Request): Promise<object> => {
	const query: any = {
		page: parseInt(req.query.page as string, 10) || 1,
		limit: parseInt(req.query.limit as string, 10) || 20,
	};

	try {
		const schedules = await scheduleSchema.find({ status: 'pending' })
			.sort({ createdAt: -1 })
			.populate('dispatches.vehicleId', 'name vehicleRegistrationNumber type capacity')
			.populate('approvedBy', 'name phoneNumber')
			.skip((query.page - 1) * query.limit)
			.limit(query.limit);

		return { schedules };
	} catch (e) {
		logger.error('Failed to get pending schedules', e);
		throw e;
	}
};

const getScheduleById = async (req: express.Request): Promise<object> => {
	try {
		const { scheduleId } = req.params;

		if (!scheduleId) {
			throw new BadRequest('Schedule ID is required');
		}

		const schedule = await scheduleSchema.findById(scheduleId)
			.populate('dispatches.vehicleId', 'name vehicleRegistrationNumber type capacity')
			.populate('approvedBy', 'name phoneNumber');

		if (!schedule) {
			throw new NotFound('Schedule not found');
		}

		// Get available vehicles for modification
		const availableVehicles = await vehicleSchema.Vehicle.find({ 
			status: 'active', 
			enRoute: false 
		}).sort({ capacity: -1 });

		return { schedule, availableVehicles };
	} catch (e) {
		logger.error('Failed to get schedule', e);
		throw e;
	}
};

const approveSchedule = async (req: express.Request): Promise<object> => {
	try {
		const { scheduleId } = req.params;
		const { action, vehicleIds, linemanNotes } = req.body;
		const linemanId = req.body.linemanId;

		if (!scheduleId) {
			throw new BadRequest('Schedule ID is required');
		}

		if (!action || !['approve', 'modify', 'reject'].includes(action)) {
			throw new BadRequest('Valid action is required (approve, modify, reject)');
		}

		if (!linemanId) {
			throw new BadRequest('Lineman ID is required');
		}

		const schedule = await scheduleSchema.findById(scheduleId);

		if (!schedule) {
			throw new NotFound('Schedule not found');
		}

		if (schedule.status !== 'pending') {
			throw new BadRequest('Schedule is not pending');
		}

		// Handle rejection
		if (action === 'reject') {
			schedule.status = 'rejected';
			schedule.approvedBy = linemanId;
			schedule.approvedAt = new Date();
			schedule.linemanNotes = linemanNotes || 'Rejected by lineman';
			await schedule.save();

			logger.info(`Schedule ${scheduleId} rejected by lineman ${linemanId}`);
			return { message: 'Schedule rejected successfully', schedule };
		}

		// Handle approval
		if (action === 'approve') {
			schedule.status = 'approved';
			schedule.approvedBy = linemanId;
			schedule.approvedAt = new Date();
			schedule.linemanNotes = linemanNotes || '';
			await schedule.save();

			// Create trips and assign reservations
			await createTripsAndAssignReservations(schedule);

			logger.info(`Schedule ${scheduleId} approved by lineman ${linemanId}`);
			return { message: 'Schedule approved successfully', schedule };
		}

		// Handle modification
		if (action === 'modify') {
			if (!vehicleIds || !Array.isArray(vehicleIds) || vehicleIds.length === 0) {
				throw new BadRequest('Vehicle IDs array is required for modification');
			}

			// Validate vehicles exist and are available
			const vehicles = await vehicleSchema.Vehicle.find({
				_id: { $in: vehicleIds },
				status: 'active',
				enRoute: false
			});

			if (vehicles.length !== vehicleIds.length) {
				throw new BadRequest('Some vehicles are not available');
			}

			// Get reservations for this schedule's time window
			const now = new Date();
			const nextHour = new Date(schedule.campusReturnTime);

			const [campusReservation, nonCampusReservation] = await Promise.all([
				reservationSchema.VehicleReservation.find({
					time: {
						$gte: now,
						$lte: nextHour,
					},
					status: 'scheduled',
					location: 'campus',
				}),
				reservationSchema.VehicleReservation.find({
					time: {
						$gte: now,
						$lte: nextHour,
					},
					status: 'scheduled',
					location: { $ne: 'campus' },
				}),
			]);

			const studentsFromCampus = campusReservation.filter(reservation => reservation.userType === 'student').length;
			const teachersFromCampus = campusReservation.filter(reservation => reservation.userType === 'teacher').length;
			const studentsFromNonCampus = nonCampusReservation.filter(reservation => reservation.userType === 'student').length;
			const teachersFromNonCampus = nonCampusReservation.filter(reservation => reservation.userType === 'teacher').length;

			let reservations;
			let students;
			let teachers;

			if (studentsFromCampus > studentsFromNonCampus) {
				students = studentsFromCampus;
				teachers = teachersFromCampus;
				reservations = campusReservation;
			} else {
				students = studentsFromNonCampus;
				teachers = teachersFromNonCampus;
				reservations = nonCampusReservation;
			}

			// Recalculate dispatch with selected vehicles
			const modifiedDispatches = calculateModifiedDispatches(
				vehicles,
				students,
				teachers,
				schedule.campusReturnTime
			);

			schedule.dispatches = modifiedDispatches;
			schedule.status = 'modified';
			schedule.approvedBy = linemanId;
			schedule.approvedAt = new Date();
			schedule.linemanNotes = linemanNotes || 'Modified by lineman';
			await schedule.save();

			// Create trips and assign reservations
			await createTripsAndAssignReservations(schedule);

			logger.info(`Schedule ${scheduleId} modified by lineman ${linemanId}`);
			return { message: 'Schedule modified and approved successfully', schedule };
		}

		throw new BadRequest('Invalid action provided');
	} catch (e) {
		logger.error('Failed to approve schedule', e);
		throw e;
	}
};

// Helper function to create trips and assign reservations
async function createTripsAndAssignReservations(schedule: any): Promise<void> {
	const now = new Date();
	const nextHour = new Date(schedule.campusReturnTime);

	// Get vehicle allocations
	const vehicleAllocation = await vehicleAllocationSchema.find({
		createdAt: {
			$gte: new Date(new Date().setDate(new Date().getDate() - 1)),
			$lt: new Date(),
		},
	});

	// Get reservations
	const [campusReservation, nonCampusReservation] = await Promise.all([
		reservationSchema.VehicleReservation.find({
			time: {
				$gte: now,
				$lte: nextHour,
			},
			status: 'scheduled',
			location: 'campus',
		}),
		reservationSchema.VehicleReservation.find({
			time: {
				$gte: now,
				$lte: nextHour,
			},
			status: 'scheduled',
			location: { $ne: 'campus' },
		}),
	]);

	const studentsFromCampus = campusReservation.filter(reservation => reservation.userType === 'student').length;
	const studentsFromNonCampus = nonCampusReservation.filter(reservation => reservation.userType === 'student').length;

	const reservations = studentsFromCampus > studentsFromNonCampus ? campusReservation : nonCampusReservation;

	// Create trips for each vehicle in the dispatches
	const trips: any[] = [];

	for (const dispatch of schedule.dispatches) {
		trips.push({
			vehicleId: dispatch.vehicleId,
			driverId: vehicleAllocation.find(alloc => alloc.vehicleId.toString() === dispatch.vehicleId.toString())?.driverId,
			scheduleId: schedule._id,
			status: 'scheduled',
			message: `Scheduled for ${dispatch.type} dispatch at ${dispatch.dispatchTime}`
		});
	}

	// Save all trip records
	if (trips.length > 0) {
		await tripSchema.insertMany(trips);
	}

	// Assign reservations to vehicles
	const studentReservations = reservations.filter(r => r.userType === 'student');
	const teacherReservations = reservations.filter(r => r.userType === 'teacher');

	let studentIndex = 0;
	let teacherIndex = 0;

	for (const dispatch of schedule.dispatches) {
		const vehicleId = dispatch.vehicleId;

		const studentsToAssign = studentReservations.slice(
			studentIndex,
			Math.min(studentIndex + dispatch.passengers.students, studentReservations.length)
		);
		studentIndex += studentsToAssign.length;

		const teachersToAssign = teacherReservations.slice(
			teacherIndex,
			Math.min(teacherIndex + dispatch.passengers.teachers, teacherReservations.length)
		);
		teacherIndex += teachersToAssign.length;

		const reservationsToUpdate = [...studentsToAssign, ...teachersToAssign];
		if (reservationsToUpdate.length > 0) {
			await reservationSchema.VehicleReservation.updateMany(
				{ _id: { $in: reservationsToUpdate.map(r => r._id) } },
				{
					vehicleId: vehicleId,
					scheduleId: schedule._id,
					status: 'onboard',
					message: `Assigned to ${dispatch.type} departing at ${dispatch.dispatchTime}`
				}
			);
		}
	}
}

// Helper function to calculate modified dispatches
function calculateModifiedDispatches(
	vehicles: any[],
	students: number,
	teachers: number,
	arrivalTime: Date
): any[] {
	const BUS_TRAVEL_TIME = 40;
	const MICROBUS_TRAVEL_TIME = 20;
	const WAITING_TIME = 10;

	const dispatches: any[] = [];
	let remainingStudents = students;
	let remainingTeachers = teachers;

	const createTripTimes = (arrivalTime: Date, isBus: boolean) => {
		const travelTime = isBus ? BUS_TRAVEL_TIME : MICROBUS_TRAVEL_TIME;
		const pickupTime = new Date(arrivalTime);
		pickupTime.setMinutes(pickupTime.getMinutes() - travelTime);

		return {
			dispatchTime: new Date(pickupTime.getTime() - (travelTime * 60000) - (WAITING_TIME * 60000)),
			pickupTime,
			returnTime: new Date(pickupTime.getTime() + (travelTime * 60000) + (WAITING_TIME * 60000))
		};
	};

	// Separate buses and microbuses
	const buses = vehicles.filter(v => v.type === 'bus').sort((a, b) => (b.capacity || 40) - (a.capacity || 40));
	const microbuses = vehicles.filter(v => v.type === 'microbus').sort((a, b) => (b.capacity || 10) - (a.capacity || 10));

	// Allocate buses for students
	for (const bus of buses) {
		if (remainingStudents <= 0) break;

		const busCapacity = bus.capacity || 40;
		const passengers = Math.min(remainingStudents, busCapacity);
		const times = createTripTimes(arrivalTime, true);

		dispatches.push({
			type: 'bus',
			...times,
			vehicleId: bus._id,
			passengers: {
				students: passengers,
				teachers: 0
			},
			notes: ''
		});

		remainingStudents -= passengers;
	}

	// Allocate microbuses for teachers and remaining students
	for (const microbus of microbuses) {
		if (remainingTeachers <= 0 && remainingStudents <= 0) break;

		const microbusCapacity = microbus.capacity || 10;
		const teachersInThisMicrobus = Math.min(remainingTeachers, microbusCapacity);
		const seatsLeft = microbusCapacity - teachersInThisMicrobus;
		const studentsInThisMicrobus = Math.min(remainingStudents, seatsLeft);

		const times = createTripTimes(arrivalTime, false);

		dispatches.push({
			type: 'microbus',
			...times,
			vehicleId: microbus._id,
			passengers: {
				students: studentsInThisMicrobus,
				teachers: teachersInThisMicrobus
			},
			notes: ''
		});

		remainingTeachers -= teachersInThisMicrobus;
		remainingStudents -= studentsInThisMicrobus;
	}

	return dispatches;
}

const linemanApi = {
	login,
	getSchedules,
	getScheduleById,
	approveSchedule
}

export default linemanApi;
