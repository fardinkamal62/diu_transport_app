import cron from 'node-cron';

import logger from './utils/logger';

import vehicleSchema from './schemas/vehicle';
import userSchema from './schemas/user';
import tripSchema from './schemas/trip';
import scheduleSchema from './schemas/schedule';

import randomAllocation from './utils/randomAllocation';
import calculateHourlyDispatch from './utils/hourlyDispatch';


// Randomly assign vehicles to users every minute
function runRandomAllocation(): void {
	logger.info('Starting random allocation cron job...');
	cron.schedule('0 6 * * *', async () => {
		try {
			const [vehicles, drivers, previousTrips] = await Promise.all([
				vehicleSchema.Vehicle.find({ status: 'active' }),
				userSchema.User.find({ groups: 'driver' }),
				// Get previous day's trips
				tripSchema.find({
					createdAt: {
						$gte: new Date(new Date().setDate(new Date().getDate() - 1)),
						$lt: new Date(),
					},
				})
			]);

			const allocations = randomAllocation(drivers, vehicles, previousTrips);

			await tripSchema.insertMany(allocations.map(allocation => ({
				driverId: allocation.driverId,
				vehicleId: allocation.vehicleId,
				status: 'scheduled',
				message: allocation.message,
			})));
			logger.info('Random allocation completed successfully!');
		} catch (error) {
			logger.error('Error during random allocation:', error);
		}
	});
}

function scheduleHourlyDispatch(): void {
	logger.info('Starting hourly dispatch cron job...');
	cron.schedule('55 * * * *', async () => {
		try {
			const vehicles = await vehicleSchema.Vehicle.find({ status: 'active', enRoute: false });
			const drivers = await userSchema.User.find({ groups: 'driver', status: 'active' });

			if (vehicles.length === 0 || drivers.length === 0) {
				logger.warn('No active vehicles or drivers found for hourly dispatch.');
				return;
			}

			const now = new Date();
			const nextHour = now;
			nextHour.setHours(now.getHours() + 1, 0, 0, 0);
			const allocatedVehicles = calculateHourlyDispatch(now, { hour: nextHour, students: 100, teachers: 20 }, drivers, vehicles);
			await scheduleSchema.insertOne(allocatedVehicles);
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
