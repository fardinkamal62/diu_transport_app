import { Request, Response } from 'express';

import api from '../apis/index';


const resetConnection = (res: { connection: { end: () => void } }): void => {
	res.connection.end(); // Reset the connection pool
};

const ping = (res: Response) : void => {
	res.status(200).send('pong!');
};


const controllers = {
	resetConnection,
	ping,
};

export default controllers;
