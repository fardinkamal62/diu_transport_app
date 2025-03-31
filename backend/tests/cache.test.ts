import cache from '../cache';
import Joi from 'joi';

describe('Cache Tests', () => {
	it('should cache data correctly', async () => {
		const testKey = 'testVehicle';
		const testData = { vehicleId: '001', latitude: '23.8103', longitude: '90.4125' };
		await cache.cacheData(testKey, testData);

		const schema = Joi.object({
			vehicleId: Joi.string().required(),
			latitude: Joi.string().required(),
			longitude: Joi.string().required(),
		});
		const result = await cache.getData(`vehicle:${testKey}`);
		expect(schema.validate(result).error).toBeUndefined();
	});

	it('should return all cached data', async () => {
		const result = await cache.getAllData();
		expect(Array.isArray(result)).toBe(true);
	});
});
