import { createClient, RedisClientType } from 'redis';
import logger from '../utils/logger';

const MAX_RETRY_TIME = 5000;
let totalRetryTime = 0;

let coOrdinateDatabaseClient: RedisClientType;
let loginCredentialsClient: RedisClientType;

const clientInit = async (database: string): Promise<any> => {
	const client = createClient({
		url: process.env.REDIS_URL || 'redis://localhost:6379',
		socket: {
			reconnectStrategy: (retries) => {
				const retryDelay = Math.min(retries * 50, 3000);
				totalRetryTime += retryDelay;

				if (totalRetryTime > MAX_RETRY_TIME) {
					logger.error('Max retry time exceeded, exiting...');
					process.exit(1);
				}

				return retryDelay;
			}
		},
		database: parseInt(database || process.env.REDIS_DB || '0', 10),
	});

	client.on('error', err => logger.error('Redis Client Error:', err));
	client.on('reconnecting', () => logger.warn('Reconnecting to Redis...'));
	client.on('connect', () => logger.info('Connected to Redis database: ' + database));

	await client.connect();
	return client;
};

const cacheInit = async (): Promise<void> => {
	// eslint-disable-next-line @typescript-eslint/no-unsafe-assignment
	coOrdinateDatabaseClient = await clientInit('0');

	// eslint-disable-next-line @typescript-eslint/no-unsafe-assignment
	loginCredentialsClient = await clientInit('1');
};

const cacheData = async (
	client: RedisClientType,
	key: string,
	data: Record<string, any>,
	ttlSeconds?: number
): Promise<void> => {
	try {
		await Promise.all(
			Object.entries(data).map(([field, value]) =>
				client.hSet(key, field, String(value))
			)
		);

		if (ttlSeconds != null) {
			await client.expire(key, ttlSeconds);
		}
	} catch (error) {
		logger.error(`Error caching data for key ${key}:`, error);
		throw error;
	}
};

const getData = async (
	client: RedisClientType,
	key: string
): Promise<Record<string, string>> => {
	try {
		return await client.hGetAll(key);
	} catch (error) {
		logger.error(`Error getting data for key ${key}:`, error);
		throw error;
	}
};

const getAllData = async (
	client: RedisClientType,
	key: string
): Promise<Array<{ key: string; value: Record<string, string> }>> => {
	try {
		const keys = await client.keys(`${key}:*`);
		return await Promise.all(
			keys.map(async (key) => {
				const value = await client.hGetAll(key);
				return { key, value };
			})
		);
	} catch (e) {
		logger.error('Error getting all data:', e);
		throw e;
	}
};

const redisDatabase = {
	cacheData,
	getData,
	getAllData,
	cacheInit,
	getcoOrdinateDatabaseClient(): RedisClientType {
		return coOrdinateDatabaseClient;
	},
	getloginCredentialsClient() : RedisClientType {
		return loginCredentialsClient;
	},
};

export default redisDatabase;
