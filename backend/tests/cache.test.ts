import redisDatabase from '../db/redis_db';
import Joi from 'joi';

describe('Cache Tests', () => {
	it('should cache data correctly', async () => {
		const testKey = 'testVehicle';
		const testData = { vehicleId: '001', latitude: '23.8103', longitude: '90.4125' };
		await redisDatabase.cacheData(redisDatabase.getcoOrdinateDatabaseClient(), testKey, testData);

		const schema = Joi.object({
			vehicleId: Joi.string().required(),
			latitude: Joi.string().required(),
			longitude: Joi.string().required(),
		});
		const result = await redisDatabase.getData(redisDatabase.getcoOrdinateDatabaseClient(),`vehicle:${testKey}`);
		expect(schema.validate(testData).error).toBeUndefined();

		expect(result).toEqual(testData);
	});

	it('should return all cached data', async () => {
		const result = await redisDatabase.getAllData(redisDatabase.getcoOrdinateDatabaseClient(), 'vehicle');
		expect(Array.isArray(result)).toBe(true);
	});
});
