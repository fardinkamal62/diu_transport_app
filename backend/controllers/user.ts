import { Request } from 'express';
import https from 'https';

import api from '../api/v1/user';
import redisDatabase from '../db/redis_db';
import logger from '../utils/logger';

const login = async (req: Request): Promise<object> => {
	const email = req.body.email as string;
	const password = req.body.password as string;
	const postData = JSON.stringify({ email, password });

	const options = {
		hostname: 'api.diu.ac',
		port: 443,
		path: '/student/login',
		method: 'POST',
		headers: {
			'Content-Type': 'application/json',
			'Content-Length': Buffer.byteLength(postData)
		}
	};

	return new Promise((resolve, reject) => {
		const request = https.request(options, (res) => {
			let data = '';
			res.on('data', (chunk) => {
				data += chunk;
			});
			res.on('end', () => {
				try {
					const result = JSON.parse(data);
					if (res.statusCode && res.statusCode >= 200 && res.statusCode < 300) {
						resolve(result);
						redisDatabase.cacheData(redisDatabase.getloginCredentialsClient(), result.token, { valid: true }, 60 * 60 * 24 * 30) // Cache for 30 days
							.then(() => {})
							.catch((err) => {
								logger.error('Error caching user credentials:', err);
							});
					} else {
						reject(new Error(result?.message || 'Authentication failed'));
					}
				} catch (e) {
					reject(new Error('Invalid JSON response'));
				}
			});
		});

		request.on('error', (e) => {
			reject(e);
		});

		request.write(postData);
		request.end();
	});
};

const addReservation = async (req: Request): Promise<object> => {
	return await api.addReservation(req);
};

const getReservations = async (req: Request): Promise<object> => {
	return await api.getReservations(req);
};

export default { login, addReservation, getReservations };
