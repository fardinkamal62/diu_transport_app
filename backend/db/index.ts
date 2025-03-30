import mongoose from 'mongoose';
import * as process from 'node:process';

import logger from '../utils/logger';

const init = async (mongoUri: string) : Promise<void> => {
	try {
		if (mongoUri) {
			await mongoose.connect(mongoUri, {
				connectTimeoutMS: 5000,
				socketTimeoutMS: 45000,
				maxPoolSize: 50,
				retryWrites: true,
			});
			logger.info(('MongoDB connected successfully'));
		} else {
			logger.error(('MongoDB URI is not provided'));
			process.exit(1);
		}
	} catch (error) {
		logger.error(('Failed to connect to MongoDB'), error);
		process.exit(1);
	}
};

const close = async (): Promise<void> => {
	try {
		logger.warn(('Closing MongoDB connection...'));
		await mongoose.connection.close();
		logger.info(('MongoDB connection closed successfully'));
	} catch (error) {
		logger.error(('Failed to close MongoDB connection'), error);
		throw error;
	}
};

const mongo = {
	init,
	close,
};

export default mongo;
