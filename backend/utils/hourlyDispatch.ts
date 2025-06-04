import { ObjectId } from 'mongodb';

interface DemandForecast {
	arrivalTime: Date;  // When passengers need to arrive at campus
	students: number;
	teachers: number;
}

interface VehicleDispatch {
	type: 'bus' | 'microbus';
	dispatchTime: Date;
	pickupTime: Date;    // When vehicle arrives at Notunbazar
	returnTime: Date;    // When vehicle returns to campus
	notes: string;
	vehicleId: ObjectId;
	passengers: {
		students: number;
		teachers: number;
	};
}

interface RemainingPassengers {
	students: number;
	teachers: number;
}

interface DispatchResult {
	availableResources: {
		buses: number;
		microbuses: number;
		busDrivers: number;
		microbusDrivers: number;
	};
	requirements: {
		teachers: number;
		students: number;
		busesNeeded: number;
		microbusesNeeded: number;
	};
	dispatches: VehicleDispatch[];
	warnings: string[];
	campusReturnTime: Date;
	remainingPassengers: RemainingPassengers;
}

export default function calculateDispatchSchedule(
	demand: DemandForecast,
	availableDrivers: any[],
	availableVehicles: any[]
): DispatchResult {
	// Constants
	const BUS_TRAVEL_TIME = 40;
	const MICROBUS_TRAVEL_TIME = 20;
	const WAITING_TIME = 10;
	const MIN_BUS_UTILIZATION = 0.5; // At least 50% of bus capacity should be used

	const warnings: string[] = [];
	const remainingPassengers: RemainingPassengers = {
		students: 0,
		teachers: 0
	};

	// Filter and sort vehicles by capacity (descending)
	const availableBuses = availableVehicles
		.filter(v => v.type === 'bus' && v.status === 'active')
		.sort((a, b) => (b.capacity || 40) - (a.capacity || 40)); // Default to 40 if capacity not specified

	const availableMicrobuses = availableVehicles
		.filter(v => v.type === 'microbus' && v.status === 'active')
		.sort((a, b) => (b.capacity || 10) - (a.capacity || 10)); // Default to 10 if capacity not specified

	// Filter drivers
	const availableBusDrivers = availableDrivers.filter(d =>
		d.status !== 'inactive' && (d.preferredVehicle?.includes('bus') || !d.preferredVehicle)
	);

	const availableMicrobusDrivers = availableDrivers.filter(d =>
		d.status !== 'inactive' && (d.preferredVehicle?.includes('microbus') || !d.preferredVehicle)
	);

	let remainingStudents =  demand.students || 0;
	let remainingTeachers =  demand.teachers || 0;
	const dispatches: VehicleDispatch[] = [];

	// Helper function to create trip times
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

	// 1. Allocate buses for students if needed (same as before)
	const studentDispatches: VehicleDispatch[] = [];
	let busIndex = 0;
	let microbusIndex = 0;

	while (remainingStudents > 0 && busIndex < availableBuses.length) {
		const bus = availableBuses[busIndex];
		const busCapacity = bus.capacity || 40;

		// Check if we should use this bus
		if (remainingStudents >= busCapacity || remainingStudents >= busCapacity * MIN_BUS_UTILIZATION) {
			const passengers = Math.min(remainingStudents, busCapacity);
			const times = createTripTimes(demand.arrivalTime, true);

			studentDispatches.push({
				type: 'bus',
				...times,
				vehicleId: new ObjectId(bus._id),
				passengers: {
					students: passengers,
					teachers: 0
				},
				notes: ''
			});

			remainingStudents -= passengers;
			busIndex++;
			continue;
		}
		break; // If not enough students for a bus, stop allocating buses
	}

	// 2. Allocate microbuses for teachers, fill remaining seats with students
	const microbusDispatches: VehicleDispatch[] = [];
	while ((remainingTeachers > 0 || remainingStudents > 0) && microbusIndex < availableMicrobuses.length) {
		const microbus = availableMicrobuses[microbusIndex];
		const microbusCapacity = microbus.capacity || 10;

		// Assign as many teachers as possible
		const teachersInThisMicrobus = Math.min(remainingTeachers, microbusCapacity);
		let seatsLeft = microbusCapacity - teachersInThisMicrobus;

		// Fill remaining seats with students
		const studentsInThisMicrobus = Math.min(remainingStudents, seatsLeft);

		const times = createTripTimes(demand.arrivalTime, false);

		microbusDispatches.push({
			type: 'microbus',
			...times,
			vehicleId: new ObjectId(microbus._id),
			passengers: {
				students: studentsInThisMicrobus,
				teachers: teachersInThisMicrobus
			},
			notes: ''
		});

		remainingTeachers -= teachersInThisMicrobus;
		remainingStudents -= studentsInThisMicrobus;
		microbusIndex++;
	}

	// Combine all dispatches
	dispatches.push(...studentDispatches, ...microbusDispatches);

	// Handle remaining passengers
	if (remainingStudents > 0) {
		warnings.push(`Could not transport ${remainingStudents} students`);
		remainingPassengers.students = remainingStudents;
	}
	if (remainingTeachers > 0) {
		warnings.push(`Could not transport ${remainingTeachers} teachers`);
		remainingPassengers.teachers = remainingTeachers;
	}

	// Check driver availability
	const usedBusDrivers = dispatches
		.filter(d => d.type === 'bus')
		.reduce((sum) => sum + 1, 0);
	const usedMicrobusDrivers = dispatches
		.filter(d => d.type === 'microbus')
		.reduce((sum) => sum + 1, 0);

	if (usedBusDrivers > availableBusDrivers.length) {
		warnings.push(`Insufficient bus drivers: Need ${usedBusDrivers}, have ${availableBusDrivers.length}`);
	}
	if (usedMicrobusDrivers > availableMicrobusDrivers.length) {
		warnings.push(`Insufficient microbus drivers: Need ${usedMicrobusDrivers}, have ${availableMicrobusDrivers.length}`);
	}

	return {
		availableResources: {
			buses: availableBuses.length,
			microbuses: availableMicrobuses.length,
			busDrivers: availableBusDrivers.length,
			microbusDrivers: availableMicrobusDrivers.length
		},
		requirements: {
			teachers: demand.teachers || 0,
			students: demand.students || 0,
			busesNeeded: dispatches.filter(d => d.type === 'bus').length,
			microbusesNeeded: dispatches.filter(d => d.type === 'microbus').length
		},
		dispatches,
		warnings,
		campusReturnTime: demand.arrivalTime,
		remainingPassengers
	};
}
