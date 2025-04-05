import cron from 'node-cron';

import logger from './utils/logger';

import vehicleSchema from './schemas/vehicle';
import userSchema from './schemas/user';
import tripSchema from './schemas/trip';

import randomAllocation from './utils/randomAllocation';


// Randomly assign vehicles to users every minute
function runRandomAllocation(): void {
	logger.info('Starting random allocation cron job...');
	cron.schedule('*/5 * * * * *', async () => {
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
		} catch (error) {
			logger.error('Error during random allocation:', error);
		}
	});
}


export default function cronJobs(): void {
	runRandomAllocation();
}
