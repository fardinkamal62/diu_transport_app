// Copyright (C) 2025 Fardin Kamal <fardinkamal62@proton.me>

import express from 'express';
import createError from 'http-errors';
import colors from 'colors';
import bodyParser from 'body-parser';
import cors from 'cors';
import 'express-async-errors';
import * as process from 'node:process';
import * as http from 'http';
import indexRoute from './routes/index'
import mongo from './db';
import errorHandler from './middlewares/error-handler';
import validators from './validators';
import api from './apis';
import cache from './cache';
import { Server } from 'socket.io';

require('dotenv').config({ path: '.env' });

const app = express();

// Create socket.io server
const server = http.createServer(app);

const io = new Server(server);

// Middleware
app.use(cors());
app.use(bodyParser.urlencoded({ extended: true }));
app.use(bodyParser.json());

// Router
app.use('/', indexRoute.router);

// Handle 404 errors
app.use((_req: any, _res: any, next: (_arg0: any) => void) => {
	next(createError(404, 'Not found'));
});

// Error handler middleware
app.use(errorHandler);

// Start the server
const PORT = process.env.port || 3000;

// Socket.io server
io.on('connection', async (socket) => {
	// On location update
	// Drivers will send their location on this channel
	socket.on('location', async (msg) => {
		const isValidLocation = validators.coOrdinateSchema.validate(msg);
		if (isValidLocation.error) {
			console.error(colors.red('Invalid location data received'));
			socket.emit('error', { message: 'Invalid location data' });
			return;
		}

		try {
			await Promise.all([
				void api.locationUpdate(msg.vehicleId, msg.latitude, msg.longitude),	// Update location in database
				void cache.cacheData(msg.vehicleId, msg),	// Cache the location data
			])
		} catch (e) {
			console.error(colors.red('Failed to update location'), e);
			socket.emit('error', { message: 'Failed to update location' });
			return;
		}

		socket.broadcast.emit('location', msg);	// Broadcast message to all connected users except the sender
		// Everyone will receive the location update
	});
});

server.listen(PORT, () => {
	console.log(colors.yellow('Starting Backend...'));
	console.log(colors.yellow('Connecting to database...'));

	if (process.env.env == null || process.env.mongo_uri == null || process.env.mongo_dev_uri == null) {
		console.error(colors.red('Environment not found'));
		process.exit(1);
	}

	// Use an IIFE to use async/await
	void (async (): Promise<void> => {
		try {
			await cache.cacheInit();

			const mongoUri = process.env.env === 'development'
				? process.env.mongo_dev_uri as string
				: process.env.mongo_uri as string;

			await mongo.init(mongoUri);
			console.log(colors.green(`Server started on port ${PORT}`));
			console.log(colors.blue(`Socket.io server started on port ${PORT}`));
		} catch (error) {
			console.log(colors.red('Error occurred, server can\'t start\n'), error);
			process.exit(1);
		}
	})();
});
