// Copyright (C) 2025 Fardin Kamal <fardinkamal62@proton.me>

import express from 'express';
import createError from 'http-errors';
import bodyParser from 'body-parser';
import cors from 'cors';
import 'express-async-errors';
import * as http from 'http';
import morgan from 'morgan';
import helmet from 'helmet';
import compression from 'compression';
import rateLimit from 'express-rate-limit';
import { config } from 'dotenv';
import swaggerUi from 'swagger-ui-express';

import indexRoute from './routes/v1/index'
import mongo from './db';
import errorHandler from './middlewares/error-handler';
import redisDatabase from './db/redis_db';
import adminRoutes from './routes/v1/admin';
import { initSocket } from './socket';
import userRoutes from './routes/v1/user';
import swaggerSpec from './swagger';

import logger from './utils/logger';
import utils from './utils';

import cronJobs from './cron';

// Load environment variables
config({ path: '.env' });

// Validate required environment variables
const requiredEnvVars = ['PORT', 'NODE_ENV', 'MONGO_URI', 'MONGO_DEV_URI', 'JWT_SECRET'];
utils.checkRequiredEnvVars(requiredEnvVars);

const app = express();

// Create socket.io server
const server = http.createServer(app);

const io = initSocket(server);

// Security middleware
app.use(helmet());

// Compression middleware
app.use(compression());

// Morgan middleware for logging
app.use(morgan(':date[iso] :method :url :status :response-time ms'));

// Rate limiting middleware
const limiter = rateLimit({
	windowMs: 15 * 60 * 1000, // 15 minutes
	limit: 100, // limit each IP to 100 requests per windowMs
	message: 'Too many requests from this IP, please try again later'
});
app.use(limiter);

// Middleware
app.use(cors());
app.use(bodyParser.urlencoded({ extended: true }));
app.use(bodyParser.json());
app.use('/api-docs', swaggerUi.serve, swaggerUi.setup(swaggerSpec));

// Router
app.use('/api/v1/admin', adminRoutes.router);
app.use('/api/v1/user', userRoutes.router);
app.use('/api/v1', indexRoute.router);

// Handle 404 errors
app.use((_req: any, _res: any, next: (_arg0: any) => void) => {
	next(createError(404, 'Not found'));
});

// Error handler middleware
app.use(errorHandler);


// Graceful shutdown
const gracefulShutdown = ():void => {
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

const PORT = process.env.PORT;
server.listen(PORT, () => {
	logger.warn('Starting Backend...');
	logger.warn('Connecting to database...');

	// Use an IIFE to use async/await
	void (async (): Promise<void> => {
		try {
			await redisDatabase.cacheInit();

			const mongoUri = process.env.NODE_ENV === 'development'
				? process.env.MONGO_DEV_URI as string
				: process.env.MONGO_URI as string;

			await mongo.init(mongoUri);
			logger.info(`Server started on port ${PORT}`);
			logger.info(`Socket.io server started on port ${PORT}`);

			// Start cron jobs
			cronJobs();
		} catch (error) {
			logger.error('Error occurred, server can\'t start\n', error);
			process.exit(1);
		}
	})();
});

export { app, server, io };
