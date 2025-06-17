import cron from 'node-cron';

import logger from './utils/logger';

import vehicleSchema from './schemas/vehicle';
import userSchema from './schemas/user';
import tripSchema from './schemas/trip';
import scheduleSchema from './schemas/schedule';
import reservationSchema from './schemas/reservation';
import vehicleAllocationSchema from './schemas/allocation';

import randomAllocation from './utils/randomAllocation';
import calculateHourlyDispatch from './utils/hourlyDispatch';


// Randomly assign vehicles to users every minute
function runRandomAllocation(): void {
    cron.schedule('0 6 * * *', async () => {
        logger.info('Starting random allocation cron job...');
        try {
            const [vehicles, drivers, previousTrips] = await Promise.all([
                vehicleSchema.Vehicle.find({status: 'active'}),
                userSchema.User.find({groups: 'driver'}),
                // Get previous day's trips
                tripSchema.find({
                    createdAt: {
                        $gte: new Date(new Date().setDate(new Date().getDate() - 1)),
                        $lt: new Date(),
                    },
                })
            ]);

            const allocations = randomAllocation(drivers, vehicles, previousTrips);
            if (allocations.length === 0) {
                logger.info('No allocations made, all vehicles are already assigned.');
                return;
            }

            await vehicleAllocationSchema.insertMany(allocations.map(allocation => ({
                vehicleId: allocation.vehicleId,
                driverId: allocation.driverId,
                message: allocation.message,
            })));

            logger.info('Random allocation completed successfully!');
        } catch (error) {
            logger.error('Error during random allocation:', error);
        }
    });
}

function scheduleHourlyDispatch(): void {
    cron.schedule('55 * * * *', async () => {
        logger.info('Starting hourly dispatch cron job...');
        try {
            const now = new Date();
            const nextHour = new Date(now);
            nextHour.setHours(now.getHours() + 2, 0, 0, 0);

            const arrivalTime = nextHour;


            const [vehicles, drivers, reservations, vehicleAllocation] = await Promise.all([
                vehicleSchema.Vehicle.find({status: 'active', enRoute: false}).sort({capacity: -1}),
                userSchema.User.find({groups: 'driver', status: 'active'}),
                reservationSchema.VehicleReservation.find({
                    time: {
                        $gte: now,
                        $lte: nextHour,
                    },
                    status: 'scheduled',
                }),
                vehicleAllocationSchema.find({
                    createdAt: {
                        $gte: new Date(new Date().setDate(new Date().getDate() - 1)),
                        $lt: new Date(),
                    },
                })
            ]);

            if (vehicles.length === 0 || drivers.length === 0) {
                logger.warn('No active vehicles or drivers found for hourly dispatch.');
                return;
            }


            const students = reservations.filter(reservation => reservation.userType === 'student').length;
            const teachers = reservations.filter(reservation => reservation.userType === 'teacher').length;

            const allocatedVehicles = calculateHourlyDispatch({arrivalTime, students, teachers}, drivers, vehicles);
            const schedule = await scheduleSchema.create(allocatedVehicles);

            // Create trips for each vehicle in the dispatches
            const trips: any[] = [];

            // For each dispatch (bus or microbus group)
            for (const dispatch of allocatedVehicles.dispatches) {
                // Create trip record
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
            // Separate reservations by user type
            const studentReservations = reservations.filter(r => r.userType === 'student');
            const teacherReservations = reservations.filter(r => r.userType === 'teacher');

            // Distribute reservations among vehicles
            let studentIndex = 0;
            let teacherIndex = 0;

            for (const dispatch of allocatedVehicles.dispatches) {
				const vehicleId = dispatch.vehicleId;

				const studentsToAssign = studentReservations.slice(
					studentIndex,
					Math.min(studentIndex + dispatch.passengers.students, studentReservations.length)
				);
				studentIndex += studentsToAssign.length;

				// Assign teachers to this vehicle
				const teachersToAssign = teacherReservations.slice(
					teacherIndex,
					Math.min(teacherIndex + dispatch.passengers.teachers, teacherReservations.length)
				);
				teacherIndex += teachersToAssign.length;

                const reservationsToUpdate = [...studentsToAssign, ...teachersToAssign];
                if (reservationsToUpdate.length > 0) {
                    await reservationSchema.VehicleReservation.updateMany(
                        {_id: {$in: reservationsToUpdate.map(r => r._id)}},
                        {
                            vehicleId: vehicleId,
                            scheduleId: schedule._id,
                            status: 'onboard',
                            message: `Assigned to ${dispatch.type} departing at ${dispatch.dispatchTime}`
                        }
                    );
                }

            }

            logger.info('Hourly dispatch scheduled successfully!');
        } catch (error) {
            logger.error('Error during hourly dispatch:', error);
        }
    });
}


export default function cronJobs(): void {
    runRandomAllocation();
    scheduleHourlyDispatch();
}
