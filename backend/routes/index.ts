import express from 'express';

const router = express.Router();

import controllers from '../controllers/index';
import middlewares from '../middlewares';

router.get('/', function (_: express.Request, res: { connection: { end: () => void } }) {
	controllers.resetConnection(res);
});

router.get('/ping', function (_: express.Request, res: express.Response) {
	controllers.ping(res);
});

router.use(middlewares.userAuth);
router.get('/api/v1/vehicle-location', async function (_: express.Request, res: express.Response) {
	try {
		const result = await controllers.getVehiclesLocation();
		res.status(200).json({ success: true, data: result });
	} catch (error) {
		res.status(500).json({ success: false, error: (error as Error).message || 'Failed to get vehicles location' });
	}
});

router.get('/api/v1/vehicles', async function (_: express.Request, res: express.Response) {
	try {
		const result = await controllers.getVehicles();
		res.status(200).json({ success: true, data: result });
	} catch (error) {
		res.status(500).json({ success: false, error: (error as Error).message || 'Failed to get vehicles data' });
	}
});

router.get('/api/v1/drivers', async function (_: express.Request, res: express.Response) {
	try {
		const result = await controllers.getDrivers();
		res.status(200).json({ success: true, data: result });
	} catch (error) {
		res.status(500).json({ success: false, error: (error as Error).message || 'Failed to get drivers data' });
	}
});


const indexRoutes = {
	router,
};

export default indexRoutes;
