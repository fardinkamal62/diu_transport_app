import mongoose from 'mongoose';

const timeWindowSchema = new mongoose.Schema({
	start: {
		type: String, // Format: "HH:MM" (24-hour)
		required: true,
		validate: {
			validator: function(v: string): boolean {
				return /^([01]\d|2[0-3]):([0-5]\d)$/.test(v);
			},
			message: 'Invalid time format. Use HH:MM (24-hour format)'
		}
	},
	end: {
		type: String, // Format: "HH:MM" (24-hour)
		required: true,
		validate: {
			validator: function(v: string): boolean {
				return /^([01]\d|2[0-3]):([0-5]\d)$/.test(v);
			},
			message: 'Invalid time format. Use HH:MM (24-hour format)'
		}
	}
}, { _id: false });

const systemSettingsSchema = new mongoose.Schema({
	// Whether the reservation system is globally enabled
	reservationEnabled: {
		type: Boolean,
		default: true,
	},
	// Day-specific reservation windows
	// 0 = Sunday, 1 = Monday, ..., 6 = Saturday
	reservationWindows: {
		type: Map,
		of: {
			enabled: {
				type: Boolean,
				default: true,
			},
			windows: [timeWindowSchema], // Multiple time windows per day
		},
		default: () => new Map([
			['0', { enabled: true, windows: [{ start: '06:00', end: '23:00' }] }], // Sunday
			['1', { enabled: false, windows: [] }], // Monday - no reservations
			['2', { enabled: true, windows: [{ start: '06:00', end: '23:00' }] }], // Tuesday
			['3', { enabled: true, windows: [{ start: '06:00', end: '23:00' }] }], // Wednesday
			['4', { enabled: true, windows: [{ start: '06:00', end: '23:00' }] }], // Thursday
			['5', { enabled: true, windows: [{ start: '06:00', end: '23:00' }] }], // Friday
			['6', { enabled: true, windows: [{ start: '09:00', end: '14:00' }, { start: '16:00', end: '19:00' }] }], // Saturday
		]),
	},
	// Maximum advance booking days
	maxAdvanceBookingDays: {
		type: Number,
		default: 7,
		min: 1,
		max: 30,
	},
	// When this settings document was last updated
	updatedAt: {
		type: Date,
		default: () => new Date(),
	},
	// Who updated it last (admin ID reference)
	updatedBy: {
		type: mongoose.Schema.Types.ObjectId,
		ref: 'User',
		required: false,
	},
}, { autoIndex: false });

// Ensure only one settings document exists
systemSettingsSchema.index({ _id: 1 }, { unique: true });

const SystemSettings = mongoose.model('SystemSettings', systemSettingsSchema);

// Helper function to get or create settings
async function getSettings(): Promise<any> {
	let settings = await SystemSettings.findOne();
	
	// If no settings exist, create default settings
	if (!settings) {
		settings = new SystemSettings({
			reservationEnabled: true,
			maxAdvanceBookingDays: 7,
		});
		await settings.save();
	}
	
	return settings;
}

// Helper function to update settings
async function updateSettings(updates: any, adminId?: string): Promise<any> {
	let settings = await getSettings();
	
	if (updates.reservationEnabled !== undefined) {
		settings.reservationEnabled = updates.reservationEnabled;
	}
	if (updates.maxAdvanceBookingDays !== undefined) {
		settings.maxAdvanceBookingDays = updates.maxAdvanceBookingDays;
	}
	if (updates.reservationWindows !== undefined) {
		settings.reservationWindows = updates.reservationWindows;
	}
	
	settings.updatedAt = new Date();
	if (adminId) {
		settings.updatedBy = adminId;
	}
	
	await settings.save();
	return settings;
}

// Helper function to check if current time is within allowed reservation windows
function isWithinReservationWindow(dayOfWeek: number, currentTime: Date): boolean {
	// This will be used by the validator
	return true; // Placeholder - will be implemented in validator
}

const schemas = {
	SystemSettings,
	getSettings,
	updateSettings,
};

export default schemas;
