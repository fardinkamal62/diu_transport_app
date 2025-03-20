import express from 'express';

const router = express.Router();

import controllers from '../controllers/index';

router.get('/', function (_: express.Request, res: { connection: { end: () => void } }) {
	controllers.resetConnection(res);
});

router.get('/api/v1/ping', function (_: express.Request, res: express.Response) {
	controllers.ping(res);
});


const indexRoutes = {
	router,
};

export default indexRoutes;
