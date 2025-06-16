import mongoose from 'mongoose';


const scheduleSchema = new mongoose.Schema({
	createdAt: {
		type: Date,
		default: ():Date => new Date(),
	},
	availableResources: {
		_id: false,
		type: {
			buses: {
				type: Number,
				required: true,
			},
			busDrivers: {
				type: Number,
				required: true,
			},
			microbuses: {
				type: Number,
				required: true,
			},
			microbusDrivers: {
				type: Number,
				required: true,
			},
		}
	},
	campusReturnTime: {
		type: Date,
		required: true,
	},
	requirements: {
		_id: false,
		type: {
			students: {
				type: Number,
				required: true,
			},
			teachers: {
				type: Number,
				required: true,
			},
			busesNeeded: {
				type: Number,
				required: true,
			},
			microbusesNeeded: {
				type: Number,
				required: true,
			},
		}
	},
	dispatches: {
		type: [{
			_id: false,
			type: {
				type: String,
				enum: ['bus', 'microbus'],
				required: true,
			},
			dispatchTime: {
				type: Date,
				required: true,
			},
			returnTime: {
				type: Date,
				required: true,
			},
			pickupTime: {
				type: Date,
				required: true,
			},
			vehicleId: {
				type: mongoose.Schema.Types.ObjectId,
				ref: 'Vehicle',
			},
			passengers: {
				type: {
					students: {
						type: Number,
						required: true,
					},
					teachers: {
						type: Number,
						required: true,
					},
				}
			},
			notes: {
				type: String,
				default: '',
			}
		}]
	},
	warnings: [{
		type: String,
	}],
	remainingPassengers: {
		_id: false,
		type: {
			students: {
				type: Number,
				default: 0,
			},
			teachers: {
				type: Number,
				default: 0,
			},
		}
	}
}, { autoIndex: false });

interface ScheduleDocument extends mongoose.Document {
	createdAt: Date;
	availableResources: {
		buses: number;
		busDrivers: number;
		microbuses: number;
		microbusDrivers: number;
	};
	campusReturnTime: Date;
	requirements: {
		students: number;
		teachers: number;
		busesNeeded: number;
		microbusesNeeded: number;
	};
	dispatches: {
		type: 'bus' | 'microbus';
		dispatchTime: Date;
		returnTime: Date;
		pickupTime: Date;
		vehicleId?: mongoose.Types.ObjectId;
		vehicle?: {
			name: string;
			vehicleRegistrationNumber: string;
			type: 'bus' | 'microbus';
		};
		passengers: {
			students: number;
			teachers: number;
		};
		notes?: string;
	}[];
	warnings: string[];
	remainingPassengers: {
		students: number;
		teachers: number;
	};
}

scheduleSchema.index({ campusReturnTime: -1 });
scheduleSchema.index({ 'dispatches.dispatchTime': -1 });

const VehicleSchedule = mongoose.model<ScheduleDocument>('VehicleSchedule', scheduleSchema);


export default VehicleSchedule;
