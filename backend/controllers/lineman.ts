import { Request } from 'express';

import api from '../api/v1/lineman';

const login = (req: Request) : Promise<object> => {
	return api.login(req);
};

const getSchedules = (req: Request) : Promise<object> => {
	return api.getSchedules(req);
};

const getScheduleById = (req: Request) : Promise<object> => {
	return api.getScheduleById(req);
};

const approveSchedule = (req: Request) : Promise<object> => {
	return api.approveSchedule(req);
};

export default { login, getSchedules, getScheduleById, approveSchedule };
