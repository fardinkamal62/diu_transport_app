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


            const [vehicles, drivers, vehicleAllocation, campusReservation, nonCampusReservation] = await Promise.all([
                vehicleSchema.Vehicle.find({status: 'active', enRoute: false}).sort({capacity: -1}),
                userSchema.User.find({groups: 'driver', status: 'active'}),
                vehicleAllocationSchema.find({
                    createdAt: {
                        $gte: new Date(new Date().setDate(new Date().getDate() - 1)),
                        $lt: new Date(),
                    },
                }),
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

            if (vehicles.length === 0 || drivers.length === 0) {
                logger.warn('No active vehicles or drivers found for hourly dispatch.');
                return;
            }

            const studentsFromCampus = campusReservation.filter(reservation => reservation.userType === 'student').length;
            const teachersFromCampus = campusReservation.filter(reservation => reservation.userType === 'teacher').length;

            const studentsFromNonCampus = nonCampusReservation.filter(reservation => reservation.userType === 'student').length;
            const teachersFromNonCampus = nonCampusReservation.filter(reservation => reservation.userType === 'teacher').length;

            let reservations;
            let students;
            let teachers;

            if(studentsFromCampus > studentsFromNonCampus) {
                students = studentsFromCampus;
                teachers = teachersFromCampus;

                reservations = campusReservation;
            } else {
                students = studentsFromNonCampus;
                teachers = teachersFromNonCampus;

                reservations = nonCampusReservation;
            }

            const allocatedVehicles = calculateHourlyDispatch({arrivalTime, students, teachers}, drivers, vehicles);
            const schedule = await scheduleSchema.create({
                ...allocatedVehicles,
                status: 'pending',
            });

            logger.info(`Hourly dispatch schedule created (ID: ${schedule._id}) and pending lineman approval`);
        } catch (error) {
            logger.error('Error during hourly dispatch:', error);
        }
    });
}


export default function cronJobs(): void {
    runRandomAllocation();
    scheduleHourlyDispatch();
}
