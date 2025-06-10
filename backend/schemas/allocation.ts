import mongoose from 'mongoose';


const allocationSchema = new mongoose.Schema({
	createdAt: {
		type: Date,
		default: ():Date => new Date(),
	},
	updatedAt: {
		type: Date,
		default: ():Date => new Date(),
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
	message: {
		type: String,
		default: '',
	},
}, { autoIndex: false });


const VehicleAllocation = mongoose.model('VehicleAllocation', allocationSchema);


export default VehicleAllocation;
