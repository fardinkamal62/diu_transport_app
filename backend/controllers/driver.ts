import { Request } from 'express';

import api from '../api/v1/driver';

const login = (req: Request) : Promise<object> => {
	return api.login(req);
};

const getAllocation = (req: Request) : Promise<object> => {
	return api.getAllocation(req);
};

const journeyToggle = (req: Request) : Promise<object> => {
	return api.journeyToggle(req);
};

const addDriverReport = (req: Request) : Promise<object> => {
	return api.addDriverReport(req);
};

const getDriverReport = (req: Request) : Promise<object> => {
	return api.getDriverReport(req);
};

const controllers = {
	login,
	getAllocation,
	journeyToggle,
	addDriverReport,
	getDriverReport,
};

export default controllers;
