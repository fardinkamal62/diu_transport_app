import { Request, Response, NextFunction, ErrorRequestHandler } from 'express';

import logger from '../utils/logger';

interface AppError extends Error {
	status?: number;
	code?: string;
	details?: string[];
}

const errorHandler: ErrorRequestHandler = (
	err: AppError,
	_req: Request,
	res: Response,
	_next: NextFunction
): void => {
	logger.error(JSON.stringify({
		message: err.message,
		status: err.status,
	}));

	if ((err.status != null) && err.message) {
		const response: any = {
			status: 'ERROR',
			message: err.message,
			code: err.status || 'UNKNOWN_ERROR',
		};

		if (err.details) {
			response.details = err.details;
		}

		res.status(err.status).json(response);
		return;
	}

	res.status(500).json({ status: 'ERROR', message: 'Internal Server Error' });
};

export default errorHandler;
