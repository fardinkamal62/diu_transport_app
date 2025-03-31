// Copyright (C) 2025 Fardin Kamal <fardinkamal62@proton.me>

import express from 'express';
import createError from 'http-errors';
import bodyParser from 'body-parser';
import cors from 'cors';
import 'express-async-errors';
import * as http from 'http';
import { Server } from 'socket.io';
import morgan from 'morgan';
import helmet from 'helmet';
import compression from 'compression';
import rateLimit from 'express-rate-limit';
import { config } from 'dotenv';

import indexRoute from './routes/index'
import mongo from './db';
import errorHandler from './middlewares/error-handler';
import validators from './validators';
import api from './apis';
import cache from './cache';
import adminRoutes from './routes/admin';

import logger from './utils/logger';
import utils from './utils';

// Load environment variables
config({ path: '.env' });

// Validate required environment variables
const requiredEnvVars = ['PORT', 'NODE_ENV', 'MONGO_URI', 'MONGO_DEV_URI'];
utils.checkRequiredEnvVars(requiredEnvVars);

const app = express();

// Security middleware
app.use(helmet());

// Compression middleware
app.use(compression());

// Morgan middleware for logging
app.use(morgan(':date[iso] :method :url :status :response-time ms'));

// Rate limiting middleware
const limiter = rateLimit({
	windowMs: 15 * 60 * 1000, // 15 minutes
	max: 100, // limit each IP to 100 requests per windowMs
	message: 'Too many requests from this IP, please try again later'
});
app.use(limiter);

// Create socket.io server
const server = http.createServer(app);

const io = new Server(server);

// Middleware
app.use(cors());
app.use(bodyParser.urlencoded({ extended: true }));
app.use(bodyParser.json());

// Router
app.use('/', indexRoute.router);
app.use('/api/v1/admin', adminRoutes.router);

// Handle 404 errors
app.use((_req: any, _res: any, next: (_arg0: any) => void) => {
	next(createError(404, 'Not found'));
});

// Error handler middleware
app.use(errorHandler);

// Start the server
const PORT = process.env.PORT || 3000;

// Socket.io server
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
			await Promise.all([
				void api.locationUpdate(msg.vehicleId, msg.latitude, msg.longitude),	// Update location in database
				void cache.cacheData(msg.vehicleId, msg),	// Cache the location data
			])
		} catch (e) {
			logger.error('Failed to update location', e);
			socket.emit('error', { message: 'Failed to update location' });
			return;
		}

		socket.broadcast.emit('location', msg);	// Broadcast message to all connected users except the sender
		// Everyone will receive the location update
	});
});

// Graceful shutdown
const gracefulShutdown = () => {
	logger.info('Shutting down gracefully...');
	server.close(() => {
		logger.info('Closed out remaining connections');
		process.exit(0);
	});

	setTimeout(() => {
		logger.error('Could not close connections in time, forcefully shutting down');
		process.exit(1);
	}, 10000);
};

process.on('SIGTERM', gracefulShutdown);
process.on('SIGINT', gracefulShutdown);
process.on('uncaughtException', (error) => {
	logger.error('Uncaught Exception:', error);
	gracefulShutdown();
});
process.on('unhandledRejection', (error) => {
	logger.error('Unhandled Rejection:', error);
	gracefulShutdown();
});
process.on('exit', (code) => {
	logger.info(`Process exited with code: ${code}`);
});

server.listen(PORT, () => {
	logger.warn('Starting Backend...');
	logger.warn('Connecting to database...');

	// Use an IIFE to use async/await
	void (async (): Promise<void> => {
		try {
			await cache.cacheInit();

			const mongoUri = process.env.NODE_ENV === 'development'
				? process.env.MONGO_DEV_URI as string
				: process.env.MONGO_URI as string;

			await mongo.init(mongoUri);
			logger.info(`Server started on port ${PORT}`);
			logger.info(`Socket.io server started on port ${PORT}`);
		} catch (error) {
			logger.error('Error occurred, server can\'t start\n', error);
			process.exit(1);
		}
	})();
});

export { app, server, io };
