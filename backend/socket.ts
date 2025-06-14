import { Server } from 'socket.io';

import validators from './validators';
import logger from './utils/logger';
import cache from './db/redis_db';

export function initSocket(server: any): Server {
	const io = new Server(server);

	io.on('connection', async (socket) => {
		// On location update
		// Drivers will send their location on this channel
		socket.on('location', async (msg) => {
			const isValidLocation = validators.coOrdinateSchema.validate(msg);
			if (isValidLocation.error) {
				logger.error('Invalid location data received');
				socket.emit('error', { message: 'Invalid location data' });
				return;
			}

			try {
				await cache.cacheData(cache.getcoOrdinateDatabaseClient(), `vehicle:${msg.vehicleId}`, msg)
			} catch (e) {
				logger.error('Failed to update location', e);
				socket.emit('error', { message: 'Failed to update location' });
				return;
			}

			io.emit('location', msg);	// Broadcast message to all connected users except the sender
			// Everyone will receive the location update
		});
	});

	return io;
}
