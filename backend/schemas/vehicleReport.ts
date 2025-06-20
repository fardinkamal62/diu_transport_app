import mongoose from 'mongoose';


const vehicleReport = new mongoose.Schema({
	createdAt: {
		type: Date,
		default: ():Date => new Date(),
	},
	time: {
		type: Date,
		required: true,
		default: (): Date => new Date(new Date().setHours(0, 0, 0, 0)), // Default to today's date
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
	damage: {
		type: String,
		enum: ['major', 'minor', 'scratch', 'none'],
		required: true,
	},
	refueling: {
		type: String,
		enum: ['1', '2', '3', '4', '5'],
		required: true,
	},
	servicing: {
		type: String,
		enum: ['interior', 'exterior', 'tire_pump', 'cleaning', 'none'],
		required: true,
	},
}, { autoIndex: false });

interface VehicleReportDocument extends mongoose.Document {
	createdAt: Date;
	time: Date;
	vehicleId: mongoose.Types.ObjectId;
	driverId: mongoose.Types.ObjectId;
	damage: 'major' | 'minor' | 'scratch' | 'none';
	refueling: '1' | '2' | '3' | '4' | '5';
	servicing: 'interior' | 'exterior' | 'tire_pump' | 'cleaning' | 'none';
	vehicle?: {
		name: string;
		registrationNumber: string;
		type: string;
	} | null;
	driver?: {
		name: string;
		phoneNumber: string;
	}
}

vehicleReport.index({ time: -1 });
vehicleReport.index({ vehicleId: 1 });

const VehicleReport = mongoose.model<VehicleReportDocument>('VehicleReport', vehicleReport);


export default VehicleReport;
