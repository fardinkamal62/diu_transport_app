import { Request, Response } from 'express';

import api from '../apis/index';


const resetConnection = (res: { connection: { end: () => void } }): void => {
	res.connection.end(); // Reset the connection pool
};

const ping = (res: Response) : void => {
	res.status(200).send('pong!');
};

const getVehiclesLocation = async (res: Response): Promise<void> => {
	try {
		const data = await api.getVehiclesLocation();
		res.status(200).send(data);
	} catch (e: any) {
		res.status(500).send(e.message);
	}
};

const controllers = {
	resetConnection,
	ping,
	getVehiclesLocation,
};

export default controllers;
