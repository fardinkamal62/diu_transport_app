import express from 'express';

const router = express.Router();

import controllers from '../../controllers/lineman';
import middlewares from '../../middlewares';
import validators from '../../validators';

/**
 * @openapi
 * /lineman/login:
 *   post:
 *     summary: Lineman login
 *     tags:
 *       - Lineman
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             properties:
 *               phoneNumber:
 *                 type: string
 *                 description: Lineman phone number
 *               password:
 *                 type: string
 *                 description: Lineman password
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

/**
 * @openapi
 * /lineman/schedules:
 *   get:
 *     summary: Get all pending dispatch schedules
 *     tags:
 *       - Lineman
 *     security:
 *       - bearerAuth: []
 *     responses:
 *       200:
 *         description: List of pending schedules
 *       400:
 *         description: Failed to fetch schedules
 */

router.get('/schedules', async (req: express.Request, res: express.Response) => {
	try {
		const result = await controllers.getSchedules(req);
		res.status(200).json({ success: true, data: result });
	} catch (error) {
		res.status(400).json({ success: false, error: (error as Error).message || 'Failed to fetch schedules' });
	}
});

/**
 * @openapi
 * /lineman/schedules/{scheduleId}:
 *   get:
 *     summary: Get schedule by ID with available vehicles
 *     tags:
 *       - Lineman
 *     security:
 *       - bearerAuth: []
 *     parameters:
 *       - in: path
 *         name: scheduleId
 *         required: true
 *         schema:
 *           type: string
 *         description: Schedule ID
 *     responses:
 *       200:
 *         description: Schedule details with available vehicles
 *       404:
 *         description: Schedule not found
 *       400:
 *         description: Failed to fetch schedule
 */

router.get('/schedules/:scheduleId', async (req: express.Request, res: express.Response) => {
	try {
		const result = await controllers.getScheduleById(req);
		res.status(200).json({ success: true, data: result });
	} catch (error) {
		res.status(400).json({ success: false, error: (error as Error).message || 'Failed to fetch schedule' });
	}
});

/**
 * @openapi
 * /lineman/schedules/{scheduleId}/approve:
 *   post:
 *     summary: Approve, modify, or reject a dispatch schedule
 *     tags:
 *       - Lineman
 *     security:
 *       - bearerAuth: []
 *     parameters:
 *       - in: path
 *         name: scheduleId
 *         required: true
 *         schema:
 *           type: string
 *         description: Schedule ID
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             properties:
 *               action:
 *                 type: string
 *                 enum: [approve, modify, reject]
 *                 description: Action to perform on the schedule
 *               linemanId:
 *                 type: string
 *                 description: ID of the lineman performing the action
 *               vehicleIds:
 *                 type: array
 *                 items:
 *                   type: string
 *                 description: Array of vehicle IDs to dispatch (required for modify action)
 *               linemanNotes:
 *                 type: string
 *                 description: Optional notes from lineman
 *             required:
 *               - action
 *               - linemanId
 *     responses:
 *       200:
 *         description: Schedule action completed successfully
 *       400:
 *         description: Invalid request or schedule not pending
 *       404:
 *         description: Schedule not found
 */

router.post('/schedules/:scheduleId/approve', async (req: express.Request, res: express.Response) => {
	try {
		const result = await controllers.approveSchedule(req);
		res.status(200).json({ success: true, data: result });
	} catch (error) {
		res.status(400).json({ success: false, error: (error as Error).message || 'Failed to process schedule' });
	}
});

const linemanRoutes = {
	router,
};

export default linemanRoutes;