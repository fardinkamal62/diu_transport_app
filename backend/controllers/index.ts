import { Request, Response } from 'express';

import api from '../apis/index';


const resetConnection = (res: { connection: { end: () => void } }): void => {
	res.connection.end(); // Reset the connection pool
};

const ping = (res: Response) : void => {
	res.status(200).send('pong!');
};

const getVehiclesLocation = async (): Promise<object> => {
	return await api.getVehiclesLocation();
};

const getVehicles = async (): Promise<object> => {
	return await api.getVehicles();
}

const getDrivers = async (): Promise<object> => {
	return await api.getDrivers();
};

const manualReservation = async (req: Request): Promise<object> => {
	return await api.manualReservation(req);
}

const controllers = {
	resetConnection,
	ping,
	getVehiclesLocation,
	getVehicles,
	getDrivers,
	manualReservation
};

export default controllers;
