import bc from 'bcrypt';
import crypto from 'node:crypto';

import logger from './logger';

const hashPassword = async (plaintextPassword: string): Promise<string> => {
	try{
		return await bc.hash(plaintextPassword, 10);
	} catch (e) {
		logger.warn(('Error hashing password'), e);
		throw e;
	}
};

const comparePassword = async (
	plaintextPassword: string,
	hash: string
): Promise<boolean> => {
	try{
		return await bc.compare(plaintextPassword, hash);
	} catch (e) {
		logger.warn(('Error comparing password'), e);
		throw e;
	}
};

const randomText = (): string => {
	return crypto.randomBytes(16).toString('hex');
};

// Validate required environment variables
function checkRequiredEnvVars(requiredEnvVars: string[]): void {
	requiredEnvVars.forEach((envVar) => {
		if (process.env[envVar] == null) {
			logger.error(`Environment variable ${envVar} is required`);
			process.exit(1);
		}
	});
}

const utils = {
	hashPassword,
	comparePassword,
	randomText,
	checkRequiredEnvVars,
};

export default utils;
