import { Schema } from 'joi';
import { NextFunction, Request, Response, RequestHandler } from 'express';
import * as jwt from 'jsonwebtoken';

import createError from 'http-errors';
import { Unauthorized } from 'http-errors';


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



const middlewares = {
	validateRequest,
	adminAuth,
};

export default middlewares;
