import { Schema } from 'joi';
import { NextFunction, Request, Response, RequestHandler } from 'express';
import * as jwt from 'jsonwebtoken';

import { Unauthorized } from 'http-errors';

import https from 'https';

import redisDatabase from '../db/redis_db';
import logger from '../utils/logger';


/**
 * Validate the request body against a schema
 * @param schema
 */
const validateRequest = (schema: Schema): RequestHandler => {
	return (req: Request, res: Response, next: NextFunction): void => {
		const { error } = schema.validate(req.body, { abortEarly: false });

		if (error) {
			res.status(400).json({
				success: false,
				message: 'Validation Error',
				details: error.details.map(detail => detail.message),
			});
			return;
		}

		next();
	};
};

/*
 * Middleware to check if the user is an admin
 */
const adminAuth = (req: Request, res: Response, next: NextFunction): void => {
	const token = req.headers.authorization;

	if (!token) {
		next(new Unauthorized('No token provided'));
		return;
	}

	try {
		const secret: string = process.env.JWT_SECRET as string;
		const decoded = jwt.verify(token, secret) as { role: string };

		if (decoded.role !== 'admin') {
			next(new Unauthorized('User is not an admin'));
			return;
		}

		next();
	} catch (error) {
		next(new Unauthorized('Failed to authenticate token'));
	}
};

// Middleware to check if the user is authenticated
const userAuth = (req: Request, _res: Response, next: NextFunction): void => {
	const token = req.headers.authorization;

	if (!token) {
		next(new Unauthorized('No token provided'));
		return;
	}

	try {
		const cachedData = redisDatabase.getData(redisDatabase.getloginCredentialsClient(), token);
		cachedData
			.then((data) => {
				if (data.valid) {
					next();
				} else {
					next(new Unauthorized('Authentication failed'));
				}
			})
			.catch((err) => {
				logger.error('Error fetching cached data:', err);
				next(new Unauthorized('Failed to fetch cached data'));
			});
	} catch (error) {
		logger.error('Error during authentication:', error);
		next(new Unauthorized('Failed to authenticate token'));
	}
};

const isAuthenticated = (req: Request, res: Response, next: NextFunction): void => {
	const token = req.headers.authorization;

	if (!token) {
		next(new Unauthorized('No token provided'));
		return;
	}

	// First try to verify as admin using JWT
	try {
		const secret: string = process.env.JWT_SECRET as string;
		const decoded = jwt.verify(token, secret) as { role: string };

		// If successful, mark as admin
		(req as any).authType = 'admin';
		(req as any).user = decoded;
		return next();
	} catch (error) {
		// Not an admin token, continue to user authentication
	}

	// Try authenticating as user through external API
	try {
		const cachedData = redisDatabase.getData(redisDatabase.getloginCredentialsClient(), token);
		cachedData
			.then((data) => {
				if (data.valid) {
					next();
				} else {
					next(new Unauthorized('Authentication failed'));
				}
			})
			.catch((err) => {
				logger.error('Error fetching cached data:', err);
				next(new Unauthorized('Failed to fetch cached data'));
			});
	} catch (error) {
		logger.error('Error during authentication:', error);
		next(new Unauthorized('Failed to authenticate token'));
	}
};

const middlewares = {
	validateRequest,
	adminAuth,
	userAuth,
	isAuthenticated
};

export default middlewares;
