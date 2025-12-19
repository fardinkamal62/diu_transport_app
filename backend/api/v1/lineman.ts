import express from 'express';

import { NotFound, Unauthorized, InternalServerError } from 'http-errors';

import userSchema from '../../schemas/user';

import logger from '../../utils/logger';
import utils from '../../utils';
import * as jwt from 'jsonwebtoken';

const User = userSchema.User;

const login = async (req: express.Request): Promise<object> => {
	const query: any = {
		groups: ['lineman'],
	};

	if (req.body.phoneNumber) {
		query.phoneNumber = req.body.phoneNumber as string;
	}

	try {
		const user = await User.findOne(query);

		if (!user) {
			throw new NotFound('Lineman not found');
		}

		const isPasswordValid = await utils.comparePassword(req.body.password, user.password);

		if (!isPasswordValid) {
			throw new Unauthorized('Invalid password');
		}

		const secret: string = process.env.JWT_SECRET as string;

		if (secret == null) {
			throw new Error('Secret not found');
		}

		const sign: string = jwt.sign({ username: user.phoneNumber, role: 'lineman' }, secret, { expiresIn: '30d' });

		if (!sign) {
			throw new InternalServerError('Failed to generate token');
		}

		return { token: sign, linemanDetails: { _id: user._id, name: user.name, phoneNumber: user.phoneNumber } };
	} catch (e) {
		logger.error(('Failed to login'), e);
		throw e;
	}
};

const linemanApi = {
	login
}

export default linemanApi;
