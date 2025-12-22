import { BadRequest } from 'http-errors';
import settingsSchema from '../schemas/settings';

/**
 * Validates if a reservation can be made at the current time
 * @param scheduledTime - The time the vehicle is scheduled to depart
 * @throws BadRequest if reservations are not allowed at this time
 */
// TODO - Test needed
export async function validateReservationTime(scheduledTime: Date): Promise<void> {
	const settings = await settingsSchema.getSettings();
	const now = new Date();
	
	// Check if reservations are globally enabled
	if (!settings.reservationEnabled) {
		throw new BadRequest('Reservation system is currently disabled. Please try again later.');
	}
	
	// Check if scheduled time is in the past
	if (scheduledTime <= now) {
		throw new BadRequest('Cannot make reservations for past times.');
	}
	
	// Check if reservation is too far in advance
	const daysDifference = (scheduledTime.getTime() - now.getTime()) / (1000 * 60 * 60 * 24);
	if (daysDifference > settings.maxAdvanceBookingDays) {
		throw new BadRequest(
			`Reservations can only be made up to ${settings.maxAdvanceBookingDays} days in advance.`
		);
	}
	
	// Check if current day/time allows reservations
	const currentDayOfWeek = now.getDay(); // 0 = Sunday, 6 = Saturday
	const daySettings = settings.reservationWindows.get(currentDayOfWeek.toString());
	
	if (!daySettings || !daySettings.enabled) {
		const dayNames = ['Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'];
		throw new BadRequest(
			`Reservations are not allowed on ${dayNames[currentDayOfWeek]}s.`
		);
	}
	
	// Check if current time is within allowed windows
	const currentHour = now.getHours();
	const currentMinute = now.getMinutes();
	const currentTimeMinutes = currentHour * 60 + currentMinute;
	
	let isWithinWindow = false;
	for (const window of daySettings.windows) {
		const [startHour, startMinute] = window.start.split(':').map(Number);
		const [endHour, endMinute] = window.end.split(':').map(Number);
		
		const startMinutes = startHour * 60 + startMinute;
		const endMinutes = endHour * 60 + endMinute;
		
		if (currentTimeMinutes >= startMinutes && currentTimeMinutes <= endMinutes) {
			isWithinWindow = true;
			break;
		}
	}
	
	if (!isWithinWindow) {
		const windowsText = daySettings.windows
			.map((w: { start: string; end: string }) => `${w.start} - ${w.end}`)
			.join(', ');
		throw new BadRequest(
			`Reservations can only be made during these times today: ${windowsText}`
		);
	}
}

/**
 * Get a user-friendly message about reservation windows
 * @returns A message string indicating when reservations are allowed
 */
export async function getReservationWindowMessage(): Promise<string> {
	const settings = await settingsSchema.getSettings();
	const now = new Date();
	const currentDayOfWeek = now.getDay();
	
	const daySettings = settings.reservationWindows.get(currentDayOfWeek.toString());
	
	if (!daySettings || !daySettings.enabled) {
		return 'Reservations are not allowed today.';
	}
	
	const windowsText = daySettings.windows
		.map((w: { start: string; end: string }) => `${w.start} - ${w.end}`)
		.join(' and ');
	
	return `Reservations are allowed today between: ${windowsText}`;
}
