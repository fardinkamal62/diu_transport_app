import express from 'express';

const router = express.Router();

import controllers from '../controllers/index';

router.get('/', function (_: express.Request, res: { connection: { end: () => void } }) {
	controllers.resetConnection(res);
});

router.get('/api/v1/ping', function (_: express.Request, res: express.Response) {
	controllers.ping(res);
});

router.get('/api/v1/vehicles', async function (_: express.Request, res: express.Response) {
	try {
		const result = await controllers.getVehiclesLocation();
		res.status(200).json({ success: true, data: result });
	} catch (error) {
		res.status(500).json({ success: false, error: (error as Error).message || 'Failed to get vehicles location' });
	}
});


const indexRoutes = {
	router,
};

export default indexRoutes;
