import mongoose from 'mongoose';


const scheduleSchema = new mongoose.Schema({
	createdAt: {
		type: Date,
		default: ():Date => new Date(),
	},
	pickupTime: {
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
			count: {
				type: Number,
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
			vehicles: [{
				type: mongoose.Schema.Types.ObjectId,
				ref: 'Vehicle',
			}],
			notes: {
				type: String,
			}
		}]
	}
}, { autoIndex: false });


const VehicleSchedule = mongoose.model('VehicleSchedule', scheduleSchema);


export default VehicleSchedule;
