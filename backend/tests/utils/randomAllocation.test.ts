import allocateVehicles from '../../utils/randomAllocation';
import { ObjectId } from 'mongodb';

import { Document } from 'mongoose';

interface Driver extends Document {
    _id: ObjectId;
    name: string;
    preferredVehicle: string[];
}

interface Vehicle extends Document {
    _id: ObjectId;
    name: string;
    type: string;
    status: string;
}

interface Trip extends Document {
    driverId: ObjectId;
    vehicleId: ObjectId;
}

describe('allocateVehicles', () => {
	const drivers = [
		{ _id: new ObjectId(), name: 'Driver 1', preferredVehicle: ['bus'] },
		{ _id: new ObjectId(), name: 'Driver 2', preferredVehicle: ['microbus'] },
		{ _id: new ObjectId(), name: 'Driver 3', preferredVehicle: [] },
	] as Driver[];

	const vehicles = [
		{ _id: new ObjectId(), name: 'Vehicle 1', type: 'bus', status: 'active' },
		{ _id: new ObjectId(), name: 'Vehicle 2', type: 'microbus', status: 'active' },
		{ _id: new ObjectId(), name: 'Vehicle 3', type: 'bus', status: 'inactive' },
		{ _id: new ObjectId(), name: 'Vehicle 4', type: 'microbus', status: 'active' },
		{ _id: new ObjectId(), name: 'Vehicle 5', type: 'bus', status: 'active' },
		{ _id: new ObjectId(), name: 'Vehicle 6', type: 'microbus', status: 'inactive' },
	] as Vehicle[];

	const previousTrips = [
		{ driverId: drivers[0]._id, vehicleId: vehicles[2]._id },
		{ driverId: drivers[1]._id, vehicleId: vehicles[1]._id },
	] as Trip[];

	it('should allocate vehicles to drivers based on their preferences', () => {
		const allocations = allocateVehicles(drivers, vehicles, previousTrips);

		expect(allocations).toHaveLength(3);
		expect(allocations[0].message).toContain('Allocated');
		expect(allocations[1].message).toContain('Allocated');
		expect(allocations[2].message).toContain('Allocated');
	});

	it('should not allocate the same vehicle to the same driver consecutively', () => {
		const allocations = allocateVehicles(drivers, vehicles, previousTrips);

		allocations.forEach(allocation => {
			if (allocation.vehicleId) {
				const previousTrip = previousTrips.find(trip => trip.driverId.equals(allocation.driverId));
				if (previousTrip) {
					expect(allocation.vehicleId).not.toEqual(previousTrip.vehicleId);
				}
			}
		});
	});

	it('should handle cases where no vehicles are available', () => {
		const noVehicles = vehicles.map(vehicle => ({ ...vehicle, status: 'inactive' }));
		// @ts-ignore
		const allocations = allocateVehicles(drivers, noVehicles, previousTrips);

		allocations.forEach(allocation => {
			expect(allocation.message).toContain('No available vehicles');
		});
	});
});