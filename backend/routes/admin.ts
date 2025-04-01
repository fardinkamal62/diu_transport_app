import express from 'express';

const router = express.Router();

import controllers from '../controllers/admin';
import middlewares from '../middlewares';
import validators from '../validators';

router.post('/login', middlewares.validateRequest(validators.loginSchema), async (req: express.Request, res: express.Response) => {
	try {
		const result = await controllers.login(req);
		res.status(200).json({ success: true, data: result });
	} catch (error) {
		res.status(400).json({ success: false, error: (error as Error).message || 'Authentication failed' });
	}
});

router.use(middlewares.adminAuth);

router.post('/add-vehicle', middlewares.validateRequest(validators.addVehicleSchema), async (req: express.Request, res: express.Response) => {
	try {
		const result = await controllers.addVehicle(req);
		res.status(200).json({ success: true, data: result });
	} catch (error) {
		res.status(400).json({ success: false, error: (error as Error).message || 'Failed to add vehicle' });
	}
});

router.post('/add-driver', middlewares.validateRequest(validators.addDriverSchema), async (req: express.Request, res: express.Response) => {
	try {
		const result = await controllers.addDriver(req);
		res.status(200).json({ success: true, data: result });
	} catch (error) {
		res.status(400).json({ success: false, error: (error as Error).message || 'Failed to add driver' });
	}
});

router.put('/update-vehicle/:id', middlewares.validateRequest(validators.addVehicleSchema), async (req: express.Request, res: express.Response) => {
	try {
		const result = await controllers.updateVehicleData(req);
		res.status(200).json({ success: true, data: result });
	} catch (error) {
		res.status(400).json({ success: false, error: (error as Error).message || 'Failed to update vehicle' });
	}
});

router.put('/update-driver/:id', middlewares.validateRequest(validators.updateDriverSchema), async (req: express.Request, res: express.Response) => {
	try {
		const result = await controllers.updateDriverData(req);
		res.status(200).json({ success: true, data: result });
	} catch (error) {
		res.status(400).json({ success: false, error: (error as Error).message || 'Failed to update driver' });
	}
});

router.delete('/delete-vehicle/:id', async (req: express.Request, res: express.Response) => {
	try {
		const result = await controllers.deleteVehicle(req);
		res.status(200).json({ success: true, data: result });
	} catch (error) {
		res.status(400).json({ success: false, error: (error as Error).message || 'Failed to delete vehicle' });
	}
});

router.delete('/delete-driver/:id', async (req: express.Request, res: express.Response) => {
	try {
		const result = await controllers.deleteDriver(req);
		res.status(200).json({ success: true, data: result });
	} catch (error) {
		res.status(400).json({ success: false, error: (error as Error).message || 'Failed to delete driver' });
	}
});

const adminRoutes = {
	router,
};

export default adminRoutes;
