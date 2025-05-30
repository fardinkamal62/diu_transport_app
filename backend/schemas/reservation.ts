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
	createdAt: {
		type: Date,
		default: ():Date => new Date(),
	},
}, { autoIndex: false });


const VehicleReservation = mongoose.model('VehicleReservation', reservationSchema);

const schemas = {
	VehicleReservation
}

export default schemas;
