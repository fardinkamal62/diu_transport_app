import mongoose from 'mongoose';
import moment from 'moment-timezone';


const vehicleSchema = new mongoose.Schema({
	registration: {
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
});

const currentLocationSchema = new mongoose.Schema({
	createdAt: {
		type: String,
		default: (): string => moment().tz('Asia/Dhaka').format(),
	},
	vehicleId: {
		type: mongoose.Schema.Types.ObjectId,
		ref: 'Vehicle',
		required: true,
	},
	latitude: {
		type: Number,
		required: true,
		min: -90,
		max: 90,
	},
	longitude: {
		type: Number,
		required: true,
		min: -180,
		max: 180,
	},
});

const Vehicle = mongoose.model('Vehicle', vehicleSchema);

const CurrentLocation = mongoose.model('CurrentLocation', currentLocationSchema);

// Add index for faster queries with vehicleId
currentLocationSchema.index({ vehicleId: 1 });

const schemas = {
	Vehicle,
	CurrentLocation,
}

export default schemas;
