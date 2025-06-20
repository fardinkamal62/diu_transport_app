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

/**
 * @openapi
 * /driver/journey:
 *   post:
 *     summary: Toggle journey status
 *     tags:
 *       - Driver
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             properties:
 *               vehicleId:
 *                 type: string
 *                 description: Vehicle ID to toggle journey status
 *             required:
 *               - vehicleId
 *     responses:
 *       200:
 *         description: Journey status toggled successfully
 *       400:
 *         description: Failed to toggle journey status
 */
router.post('/journey', async (req: express.Request, res: express.Response) => {
	try {
		const result = await controllers.journeyToggle(req);
		res.status(200).json({ success: true, data: result });
	} catch (error) {
		res.status(400).json({ success: false, error: (error as Error).message || 'Failed to toggle journey' });
	}
});

/**
 * @openapi
 * /driver/report:
 *   post:
 *     summary: Add driver report
 *     tags:
 *       - Driver
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             properties:
 *               time:
 *                 type: string
 *                 format: date-time
 *                 description: Time of the report
 *               vehicleId:
 *                 type: string
 *                 description: Vehicle ID associated with the report
 *               driverId:
 *                 type: string
 *                 description: Driver ID associated with the report
 *               damage:
 *                 type: string
 *                 enum: ['major', 'minor', 'scratch', 'none']
 *                 description: Damage level reported
 *               refueling:
 *                 type: string
 *                 enum: ['1', '2', '3', '4', '5']
 *                 description: Refueling level reported
 *               servicing:
 *                 type: string
 *                 enum: ['interior', 'exterior', 'tire_pump', 'cleaning', 'none']
 *                 description: Servicing level reported
 *             required:
 *               - time
 *               - vehicleId
 *               - driverId
 *               - damage
 *               - refueling
 *               - servicing
 */
router.post('/report', middlewares.validateRequest(validators.addDriverReportSchema), async (req: express.Request, res: express.Response) => {
	try {
		const result = await controllers.addDriverReport(req);
		res.status(200).json({ success: true, data: result });
	} catch (error) {
		res.status(400).json({ success: false, error: (error as Error).message || 'Failed to add driver report' });
	}
});

/**
 * @openapi
 * /driver/report:
 *   get:
 *     summary: Get driver report
 *     tags:
 *       - Driver
 *     parameters:
 *       - in: query
 *         name: driverId
 *         schema:
 *           type: string
 *         description: Driver ID to filter reports
 *       - in: query
 *         name: vehicleId
 *         schema:
 *           type: string
 *         description: Vehicle ID to filter reports
 *       - in: query
 *         name: time
 *         schema:
 *           type: string
 *           format: date-time
 *         description: Time to filter reports
 *     responses:
 *       200:
 *         description: Successfully fetched driver report
 */
router.get('/report', async (req: express.Request, res: express.Response) => {
	try {
		const result = await controllers.getDriverReport(req);
		res.status(200).json({ success: true, data: result });
	} catch (error) {
		res.status(400).json({ success: false, error: (error as Error).message || 'Failed to fetch driver report' });
	}
});

const driverRoutes = { router }
export default driverRoutes;
