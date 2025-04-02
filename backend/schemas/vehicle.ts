import mongoose from 'mongoose';


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
		type: Date,
		default: (): Date => new Date(),
	},
	updatedAt: {
		type: Date,
		default: (): Date => new Date(),
	},
	deletedAt: {
		type: Date,
		default: null,
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
	capacity: {
		type: Number,
		required: true,
	},
	reservedSeats: {
		type: Number,
		default: 0,
	},
}, { autoIndex: false });

const Vehicle = mongoose.model('Vehicle', vehicleSchema);

const schemas = {
	Vehicle,
}

export default schemas;

