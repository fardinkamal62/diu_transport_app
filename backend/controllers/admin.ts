import { Request } from 'express';

import api from '../apis/admin';

const login = (req: Request) : Promise<object> => {
	return api.login(req);
};

const addVehicle = (req: Request) : Promise<object> => {
	return api.addVehicle(req);
};

const addDriver = (req: Request) : Promise<object> => {
	return api.addDriver(req);
};

const controllers = {
	login,
	addVehicle,
	addDriver,
};

export default controllers;
