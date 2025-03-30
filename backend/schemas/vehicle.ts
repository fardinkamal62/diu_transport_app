import mongoose from 'mongoose';
import moment from 'moment-timezone';


const vehicleSchema = new mongoose.Schema({
	name: {
		type: String,
		required: true,
	},
	vehicleRegistrationNumber: {
		type: String,
		required: true,
		unique: true,
	},
	type: {
		type: String,
		required: true,
		enum: ['bus', 'microbus'],
	},
	createdAt: {
		type: String,
		default: (): string => moment().tz('Asia/Dhaka').format(),
	},
	updatedAt: {
		type: String,
		default: (): string => moment().tz('Asia/Dhaka').format()
	},
	status: {
		type: String,
		enum: ['active', 'inactive'],
		default: 'inactive',
	},
	enRoute: {
		type: Boolean,
		default: false,
	},
}, { autoIndex: false });

const Vehicle = mongoose.model('Vehicle', vehicleSchema);

const schemas = {
	Vehicle,
}

export default schemas;

