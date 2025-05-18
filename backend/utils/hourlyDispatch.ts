import { ObjectId } from 'mongodb';

interface demandForecast {
    hour: Date,
    students: number,
    teachers: number
}

interface dispatches {
    type: string,
    count: number,
    dispatchTime: Date,
    returnTime: Date,
    notes?: string,
	vehicles: ObjectId[],
}

export default function calculateHourlyDispatch(currentTime: Date, demandForecast: demandForecast, availableDrivers: any[], availableVehicles: any[]): object {
	// Constants
	const BUS_TRAVEL_TIME = 40; // minutes to pickup point
	const MICROBUS_TRAVEL_TIME = 20; // minutes to pickup point
	const WAITING_TIME = 10; // minutes at pickup point
	const BUS_CAPACITY = 40;
	const MICROBUS_CAPACITY = 11;

	// Filter available resources
	const activeBuses = availableVehicles.filter(v => v.type === 'bus');

	const activeMicrobuses = availableVehicles.filter(v => v.type === 'microbus');

	const availableBusDrivers = availableDrivers.filter(d => d.status !== 'inactive');

	const availableMicrobusDrivers = availableDrivers.filter(d => d.status !== 'inactive');

	const pickupTime = new Date(currentTime);

	// Calculate required vehicles
	const teachers = demandForecast.teachers || 0;
	const students = demandForecast.students || 0;

	// Teachers must go in microbuses (priority)
	const microbusesForTeachers = Math.ceil(teachers / MICROBUS_CAPACITY);
	const remainingMicrobuses = Math.max(0, activeMicrobuses.length - microbusesForTeachers);

	// Allocate remaining microbuses to students
	const studentsInMicrobuses = Math.min(
		students,
		remainingMicrobuses * MICROBUS_CAPACITY
	);
	const remainingStudents = Math.max(0, students - studentsInMicrobuses);

	// Allocate buses to remaining students
	const busesNeeded = Math.ceil(remainingStudents / BUS_CAPACITY);

	// Calculate dispatch times
	const busDispatchTime = new Date(pickupTime);
	busDispatchTime.setMinutes(busDispatchTime.getMinutes() - BUS_TRAVEL_TIME);

	const microbusDispatchTime = new Date(pickupTime);
	microbusDispatchTime.setMinutes(microbusDispatchTime.getMinutes() - MICROBUS_TRAVEL_TIME);

	// Calculate return times
	const busReturnTime = new Date(pickupTime);
	busReturnTime.setMinutes(busReturnTime.getMinutes() + WAITING_TIME + BUS_TRAVEL_TIME);

	const microbusReturnTime = new Date(pickupTime);
	microbusReturnTime.setMinutes(microbusReturnTime.getMinutes() + WAITING_TIME + MICROBUS_TRAVEL_TIME);


	const dispatches = [] as dispatches[];

	// Schedule bus dispatches if needed
	if (busesNeeded > 0) {
		dispatches.push({
			type: 'bus',
			count: Math.min(busesNeeded, activeBuses.length, availableBusDrivers.length),
			dispatchTime: busDispatchTime,
			returnTime: busReturnTime,
			vehicles: activeBuses.slice(0, Math.min(busesNeeded, activeBuses.length, availableBusDrivers.length)).map(m => new ObjectId(m._id)),
			notes: busesNeeded > activeBuses.length ? `Shortage of ${busesNeeded - activeBuses.length} buses` :
				busesNeeded > availableBusDrivers.length ? `Shortage of ${busesNeeded - availableBusDrivers.length} bus drivers` : undefined
		});
	}

	// Schedule microbus dispatches
	const totalMicrobusesNeeded = microbusesForTeachers + Math.ceil(studentsInMicrobuses / MICROBUS_CAPACITY);
	if (totalMicrobusesNeeded > 0) {
		dispatches.push({
			type: 'microbus',
			count: Math.min(totalMicrobusesNeeded, activeMicrobuses.length, availableMicrobusDrivers.length),
			dispatchTime: microbusDispatchTime,
			returnTime: microbusReturnTime,
			vehicles: activeMicrobuses.slice(0, Math.min(totalMicrobusesNeeded, activeMicrobuses.length, availableMicrobusDrivers.length)).map(m => new ObjectId(m._id)),
			notes: totalMicrobusesNeeded > activeMicrobuses.length ? `Shortage of ${totalMicrobusesNeeded - activeMicrobuses.length} microbuses` :
				totalMicrobusesNeeded > availableMicrobusDrivers.length ? `Shortage of ${totalMicrobusesNeeded - availableMicrobusDrivers.length} microbus drivers` : undefined
		});
	}

	return {
		availableResources: {
			buses: activeBuses.length,
			microbuses: activeMicrobuses.length,
			busDrivers: availableBusDrivers.length,
			microbusDrivers: availableMicrobusDrivers.length
		},
		pickupTime: pickupTime,
		requirements: {
			teachers,
			students,
			busesNeeded,
			microbusesNeeded: microbusesForTeachers + Math.ceil(studentsInMicrobuses / MICROBUS_CAPACITY)
		},
		dispatches,
	};
}
