export default function allocateVehicles(drivers: any[], vehicles: any[], previousTrips: any[]): Array<{ driverId: any; vehicleId?: any; message: string; }> {
	// Create a map to track the last vehicle each driver drove
	const lastVehicleMap = {};

	// Populate the lastVehicleMap from previous trips
	previousTrips.forEach(trip => {
		// eslint-disable-next-line @typescript-eslint/no-unsafe-assignment
		const driverId = trip.driverId.toString();
		// @ts-ignore
		// eslint-disable-next-line @typescript-eslint/no-unsafe-assignment
		lastVehicleMap[driverId] = trip.vehicleId.toString();
	});

	// Create a result array to hold the new allocations
	const allocations: { driverId: any; vehicleId?: any; message: string; }[] = [];

	// Iterate over each driver
	drivers.forEach(driver => {
		// eslint-disable-next-line @typescript-eslint/no-unsafe-assignment
		const driverId = driver._id.toString();
		// eslint-disable-next-line @typescript-eslint/no-unsafe-assignment
		const preferredVehicles = driver.preferredVehicle || []; // Get preferred vehicles if any

		// Filter vehicles based on driver's capabilities and exclude the last vehicle
		const availableVehicles = vehicles.filter((vehicle): boolean => {
			// eslint-disable-next-line @typescript-eslint/no-unsafe-assignment
			const vehicleId = vehicle._id.toString();
			// eslint-disable-next-line @typescript-eslint/no-unsafe-assignment
			const isPreferred = preferredVehicles.length === 0 || preferredVehicles.includes(vehicle.type);
			// @ts-ignore
			const isNotLastVehicle = lastVehicleMap[driverId] !== vehicleId;
			return vehicle.status === 'active' && isPreferred && isNotLastVehicle;
		});

		// If there are available vehicles, randomly select one
		if (availableVehicles.length > 0) {
			const randomIndex = Math.floor(Math.random() * availableVehicles.length);
			// eslint-disable-next-line @typescript-eslint/no-unsafe-assignment
			const selectedVehicle = availableVehicles[randomIndex];
			// @ts-ignore
			const lastVehicle = (vehicles.find(vehicle => vehicle._id.toString() === lastVehicleMap[driverId])) || { name: '' };

			// Add the allocation to the result
			// @ts-ignore
			allocations.push({
				// eslint-disable-next-line @typescript-eslint/no-unsafe-assignment
				driverId: driverId,
				// eslint-disable-next-line @typescript-eslint/no-unsafe-assignment
				vehicleId: selectedVehicle._id.toString(),
				// @ts-ignore
				message: `Allocated ${selectedVehicle.name} to ${driver.name}. Previous vehicle was ${(lastVehicleMap[driverId] !== '') ? lastVehicle.name : 'none'}.`
			});

			// Remove the selected vehicle from the available vehicles list
			vehicles = vehicles.filter(vehicle => vehicle._id.toString() !== selectedVehicle._id.toString());
		} else {
			allocations.push({
				// eslint-disable-next-line @typescript-eslint/no-unsafe-assignment
				driverId: driverId,
				message: `No available vehicles for ${driver.name}.`
			});
		}
	});

	return allocations;
}

// TODO: Fix the type errors
