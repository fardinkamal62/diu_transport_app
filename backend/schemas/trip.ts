import mongoose from 'mongoose';


const tripSchema = new mongoose.Schema({
	createdAt: {
		type: Date,
		default: ():Date => new Date(),
	},
	updatedAt: {
		type: Date,
		default: null,
	},
	vehicleId: {
		type: mongoose.Schema.Types.ObjectId,
		ref: 'Vehicle',
		required: true,
	},
	driverId: {
		type: mongoose.Schema.Types.ObjectId,
		ref: 'User',
		required: true,
	},
	status: {
		type: String,
		enum: ['scheduled', 'in-progress', 'completed', 'cancelled'],
		default: 'scheduled',
	},
	message: {
		type: String,
		default: '',
	},
}, { autoIndex: false });


const Trip = mongoose.model('Trip', tripSchema);


export default Trip;
