import mongoose from 'mongoose';


const reservationSchema = new mongoose.Schema({
	registrationCode: {
		type: String,
		required: true,
	},
	time: {
		type: Date,
		required: true,
	},
	location: {
		type: String,
		required: true,
		enum: ['campus', 'notunbazar', 'sayeednagar']
	},
	userType: {
		type: String,
		required: true,
		enum: ['student', 'teacher', 'staff'],
	},
	status: {
		type: String,
		enum: ['scheduled', 'cancelled', 'completed', 'onboard'],
		default: 'pending',
	},
	message: {
		type: String,
		default: '',
	},
	vehicleId: {
		type: mongoose.Schema.Types.ObjectId,
		ref: 'Vehicle',
	},
	createdAt: {
		type: Date,
		default: ():Date => new Date(),
	},
}, { autoIndex: false });


interface VehicleReservationDocument extends mongoose.Document {
	registrationCode: string;
	time: Date;
	location: 'campus' | 'notunbazar' | 'sayeednagar';
	userType: 'student' | 'teacher' | 'staff';
	status?: 'scheduled' | 'cancelled' | 'completed' | 'onboard';
	message?: string;
	vehicleId?: mongoose.Types.ObjectId;
	vehicle?: {
		name: string;
		registrationNumber: string;
		type: string;
	} | null;
}

reservationSchema.index({ time: -1 });
reservationSchema.index({ registrationCode: 1, time: -1 });

const VehicleReservation = mongoose.model<VehicleReservationDocument>('VehicleReservation', reservationSchema);

const schemas = {
	VehicleReservation
}

export default schemas;
