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

const updateVehicleData = (req: Request) : Promise<object> => {
	return api.updateVehicleData(req);
}

const updateDriverData = (req: Request) : Promise<object> => {
	return api.updateDriverData(req);
};

const deleteVehicle = (req: Request) : Promise<object> => {
	return api.deleteVehicle(req);
}

const deleteDriver = (req: Request) : Promise<object> => {
	return api.deleteDriver(req);
};

const controllers = {
	login,
	addVehicle,
	addDriver,
	updateVehicleData,
	updateDriverData,
	deleteVehicle,
	deleteDriver,
};

export default controllers;
