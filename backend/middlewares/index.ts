import { Schema } from 'joi';
import { NextFunction, Request, Response, RequestHandler } from 'express';
import * as jwt from 'jsonwebtoken';

import createError from 'http-errors';
import { Unauthorized } from 'http-errors';

import https from 'https';


interface ValidationError extends createError.HttpError {
	details?: string[];
}

/**
 * Validate the request body against a schema
 * @param schema
 */
const validateRequest = (schema: Schema): RequestHandler => {
	return (req: Request, _res: Response, next: NextFunction): void => {
		const { error } = schema.validate(req.body, { abortEarly: false });

		if (error) {
			const validationError: ValidationError = createError(400, 'Validation Error');
			validationError.details = error.details.map(detail => detail.message);
			next(validationError);
		}

		next();
	};

};

/*
 * Middleware to check if the user is an admin
 */
const adminAuth = (req: Request, res: Response, next: NextFunction): void => {
	const token = req.headers.authorization?.split(' ')[1];

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
	const token = req.headers.authorization?.split(' ')[1];

	if (!token) {
		next(new Unauthorized('No token provided'));
		return;
	}

	const options = {
		hostname: 'api.diu.ac',
		port: 443,
		path: `/student/profile?token=${token}`,
		method: 'GET',
		headers: {
			'User-Agent': 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:138.0) Gecko/20100101 Firefox/138.0',
			'Referer': 'https://students.diu.ac/',
			'Content-Type': 'application/json',
		},
	};

	delete req.headers['authorization'];
	const request = https.request(options, (res) => {
		let data = '';
		res.on('data', (chunk) => {
			data += chunk;
		});
		res.on('end', () => {
			try {
				const result = JSON.parse(data);
				if (res.statusCode && res.statusCode >= 200 && res.statusCode < 300) {
					// Optionally attach user info to req object
					(req as any).user = result;
					next();
				} else {
					next(new Unauthorized(result?.message || 'Authentication failed'));
				}
			} catch (e) {
				next(new Unauthorized('Invalid JSON response'));
			}
		});
	});

	request.on('error', (e) => {
		next(new Unauthorized(e.message));
	});

	// request.write(postData);
	request.end();
};

const middlewares = {
	validateRequest,
	adminAuth,
	userAuth,
};

export default middlewares;
