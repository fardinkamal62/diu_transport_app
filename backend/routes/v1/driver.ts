import express from 'express';

const router = express.Router();

import controllers from '../../controllers/driver';
import middlewares from '../../middlewares';
import validators from '../../validators';

/**
 * @openapi
 * /driver/login:
 *   post:
 *     summary: Driver login
 *     tags:
 *       - Driver
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             properties:
 *               email:
 *                 type: string
 *                 description: Admin email
 *               username:
 *                 type: string
 *                 description: Admin username
 *               password:
 *                 type: string
 *                 description: Admin password
 *                 format: password
 *             required:
 *               - password
 *     responses:
 *       200:
 *         description: Successful login
 *       400:
 *         description: Authentication failed
 */
router.post('/login', middlewares.validateRequest(validators.driverLoginSchema), async (req: express.Request, res: express.Response) => {
	try {
		const result = await controllers.login(req);
		res.status(200).json({ success: true, data: result });
	} catch (error) {
		res.status(400).json({ success: false, error: (error as Error).message || 'Authentication failed' });
	}
});

router.get('/allocation', async (req: express.Request, res: express.Response) => {
	try {
		const result = await controllers.getAllocation(req);
		res.status(200).json({ success: true, data: result });
	} catch (error) {
		res.status(400).json({ success: false, error: (error as Error).message || 'Allocation fetching failed' });
	}
});

router.post('/journey', async (req: express.Request, res: express.Response) => {
	try {
		const result = await controllers.journeyToggle(req);
		res.status(200).json({ success: true, data: result });
	} catch (error) {
		res.status(400).json({ success: false, error: (error as Error).message || 'Failed to toggle journey' });
	}
});

router.use(middlewares.adminAuth);

const driverRoutes = { router }
export default driverRoutes;
