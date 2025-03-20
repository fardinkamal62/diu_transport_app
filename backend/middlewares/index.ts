import { Schema } from 'joi';
import { NextFunction, Request, Response, RequestHandler } from 'express';

import createError from 'http-errors';

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


const middlewares = {
	validateRequest,
};

export default middlewares;
