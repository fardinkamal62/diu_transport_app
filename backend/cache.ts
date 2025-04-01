import { createClient } from 'redis';

import logger from './utils/logger';

const client = createClient({
	url: process.env.REDIS_URL || 'redis://localhost:6379',
	socket: {
		reconnectStrategy: (retries) => Math.min(retries * 50, 3000)
	}
});

const cacheInit = async (): Promise<void> => {
	client.on('error', err => logger.error(('Redis Client Error:'), err));
	client.on('reconnecting', () => logger.warn(('Reconnecting to Redis...')));
	client.on('connect', () => logger.info(('Connected to Redis')));
	await client.connect()
};

const cacheData = async (key: string, data: Record<string, any>): Promise<void> => {
	try {
		// For each property in data, set as field-value pair
		const vehicleKey = `vehicle:${key}`;
		await Promise.all(
			Object.entries(data).map(([field, value]) =>
				client.hSet(vehicleKey, field, String(value))
			)
		);
	} catch (error) {
		logger.error((`Error caching data for key ${key}:`), error);
		throw error;
	}
};

const getData = async (key: string): Promise<Record<string, string>> => {
	try {
		return await client.hGetAll(key);
	} catch (error) {
		logger.error((`Error getting data for key ${key}:`), error);
		throw error;
	}
};

const getAllData = async (): Promise<Array<{key: string, value: Record<string, string>}>> => {
	try {
		const keys = await client.keys('vehicle:*');
		return await Promise.all(keys.map(async (key) => {
			const value = await client.hGetAll(key);
			return { key, value };
		}));
	} catch (e) {
		logger.error(('Error getting all data:'), e);
		throw e;
	}
};

const cache = {
	cacheData,
	getData,
	getAllData,
	cacheInit,
}

export default cache;
