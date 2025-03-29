import mongoose from 'mongoose';
import moment from 'moment-timezone';


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

// Add index for faster queries with vehicleId
currentLocationSchema.index({ vehicleId: 1 });

const CurrentLocation = mongoose.model('CurrentLocation', currentLocationSchema);

const schemas = {
	CurrentLocation,
}

export default schemas;
