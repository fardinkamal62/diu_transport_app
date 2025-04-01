import mongoose from 'mongoose';


const currentLocationSchema = new mongoose.Schema({
	createdAt: {
		type: Date,
		default: (): Date => new Date(),
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
}, { autoIndex: false });

// Add index for faster queries with vehicleId
currentLocationSchema.index({ vehicleId: 1 });

const CurrentLocation = mongoose.model('CurrentLocation', currentLocationSchema);

const schemas = {
	CurrentLocation,
}

export default schemas;

