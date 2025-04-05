import { Document } from 'mongoose';
import { ObjectId } from 'mongodb';

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

export default function allocateVehicles(drivers: Driver[], vehicles: Vehicle[], previousTrips: Trip[]): Array<{
    driverId: ObjectId;
    vehicleId?: ObjectId;
    message: string;
}> {
	// Create a map to track the last vehicle each driver drove
	const lastVehicleMap = new Map<string, string>();

	// Populate the lastVehicleMap from previous trips
	previousTrips.forEach(trip => {
		const driverId = trip.driverId.toString() as string;
		lastVehicleMap.set(driverId, trip.vehicleId.toString() as string);
	});

	// Create a result array to hold the new allocations
	const allocations: { driverId: ObjectId; vehicleId?: ObjectId; message: string; }[] = [];

	// Iterate over each driver
	drivers.forEach(driver => {
		const driverId = driver._id.toString() as string;
		const preferredVehicles = driver.preferredVehicle as string[];

		// Filter vehicles based on driver's capabilities and exclude the last vehicle
		const availableVehicles = vehicles.filter((vehicle): boolean => {
			const vehicleId = vehicle._id.toString() as string;
			const isPreferred = preferredVehicles.length === 0 || preferredVehicles.includes(vehicle.type);
			const isNotLastVehicle = lastVehicleMap.get(driverId) !== vehicleId;
			return vehicle.status === 'active' && isPreferred && isNotLastVehicle;
		});

		// If there are available vehicles, randomly select one
		if (availableVehicles.length > 0) {
			const randomIndex = Math.floor(Math.random() * availableVehicles.length);
			const selectedVehicle = availableVehicles[randomIndex];
			const lastVehicle = (vehicles.find(vehicle => vehicle._id.toString() === lastVehicleMap.get(driverId))) as Vehicle || { name: '' };

			// Add the allocation to the result
			allocations.push({
				driverId: new ObjectId(driverId),
				vehicleId: selectedVehicle._id,
				message: `Allocated ${selectedVehicle.name} to ${driver.name}. Previous vehicle was ${(lastVehicle) ? lastVehicle.name : 'none'}.`
			});

			// Remove the selected vehicle from the available vehicles list
			vehicles = vehicles.filter(vehicle => vehicle._id.toString() !== selectedVehicle._id.toString());
		} else {
			allocations.push({
				driverId: new ObjectId(driverId),
				message: `No available vehicles for ${driver.name}.`
			});
		}
	});

	return allocations;
}
