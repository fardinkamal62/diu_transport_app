import { createClient } from 'redis';

const client = createClient();


const cacheInit = async (): Promise<void> => {
	client.on('error', err => console.log('Redis Client Error', err));
	await client.connect()
};

const cacheData = async (key: string, data: any): Promise<void> => {
	await client.hSet(`vehicle:${key}`, data);
};

const getData = async (key: string): Promise<any> => {
	return await client.hGetAll(key);
};

const getAllData = async (): Promise<any> => {
	const keys = await client.keys('vehicle:*');
	return await Promise.all(keys.map(async (key) => {
		const value = await client.hGetAll(key);
		return { key, value };
	}));
};

const cache = {
	cacheData,
	getData,
	getAllData,
	cacheInit,
}

export default cache;
