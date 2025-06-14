import { Request } from 'express';

import api from '../api/v1/driver';

const login = (req: Request) : Promise<object> => {
	return api.login(req);
};

const getAllocation = (req: Request) : Promise<object> => {
	return api.getAllocation(req);
};

const controllers = {
	login,
	getAllocation
};

export default controllers;
