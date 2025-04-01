import request from 'supertest';
import Joi from 'joi';
import { Server } from 'http';
import { app } from '../index';

describe('Index Tests', () => {
	let server: Server;

	beforeAll(() => {
		server = app.listen(0);
	});

	afterAll(() => {
		server.close();
	});

	it('should return 404 for unknown routes', async () => {
		const response = await request(server).get('/unknown');
		expect(response.status).toBe(404);
	});

	it('should validate location payload with JOI', async () => {
		const schema = Joi.object({
			vehicleId: Joi.string().required(),
			latitude: Joi.number().required(),
			longitude: Joi.number().required()
		});
		const validData = {
			vehicleId: '123',
			latitude: 23.8103,
			longitude: 90.4125
		};
		const { error } = schema.validate(validData);
		expect(error).toBeUndefined();
	});
});
