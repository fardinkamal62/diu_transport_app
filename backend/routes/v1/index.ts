import express from 'express';

const router = express.Router();

import controllers from '../../controllers/index';
import middlewares from '../../middlewares';

/**
 * @openapi
 * /:
 *   get:
 *     summary: Reset the connection
 *     tags:
 *      - Connection
 *     responses:
 *       200:
 *         description: Connection reset successfully
 */
router.get('/', function (_: express.Request, res: { connection: { end: () => void } }) {
	controllers.resetConnection(res);
});

/**
 * @openapi
 * /ping:
 *   get:
 *     summary: Health check endpoint
 *     tags:
 *      - Connection
 *     responses:
 *       200:
 *         description: Pong response
 */
router.get('/ping', function (_: express.Request, res: express.Response) {
	controllers.ping(res);
});

router.use(middlewares.isAuthenticated);

/**
 * @openapi
 * /vehicle-location:
 *   get:
 *     summary: Get current locations of all vehicles
 *     security:
 *       - ApiKeyAuth: []
 *     tags:
 *       - Vehicle & Driver
 *     responses:
 *       200:
 *         description: List of vehicle locations
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 success:
 *                   type: boolean
 *                 data:
 *                   type: array
 *                   items:
 *                     type: object
 *       500:
 *         description: Failed to get vehicles location
 */
router.get('/vehicle-location', async function (_: express.Request, res: express.Response) {
	try {
		const result = await controllers.getVehiclesLocation();
		res.status(200).json({ success: true, data: result });
	} catch (error) {
		res.status(500).json({ success: false, error: (error as Error).message || 'Failed to get vehicles location' });
	}
});

/**
 * @openapi
 * /vehicles:
 *   get:
 *     summary: Get all vehicles
 *     security:
 *       - ApiKeyAuth: []
 *     tags:
 *       - Vehicle & Driver
 *     responses:
 *       200:
 *         description: List of vehicles
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 success:
 *                   type: boolean
 *                 data:
 *                   type: array
 *                   items:
 *                     type: object
 *       500:
 *         description: Failed to get vehicles data
 */
router.get('/vehicles', async function (_: express.Request, res: express.Response) {
	try {
		const result = await controllers.getVehicles();
		res.status(200).json({ success: true, data: result });
	} catch (error) {
		res.status(500).json({ success: false, error: (error as Error).message || 'Failed to get vehicles data' });
	}
});

/**
 * @openapi
 * /drivers:
 *   get:
 *     summary: Get all drivers
 *     security:
 *       - ApiKeyAuth: []
 *     tags:
 *       - Vehicle & Driver
 *     responses:
 *       200:
 *         description: List of drivers
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 success:
 *                   type: boolean
 *                 data:
 *                   type: array
 *                   items:
 *                     type: object
 *       500:
 *         description: Failed to get drivers data
 */
router.get('/drivers', async function (_: express.Request, res: express.Response) {
	try {
		const result = await controllers.getDrivers();
		res.status(200).json({ success: true, data: result });
	} catch (error) {
		res.status(500).json({ success: false, error: (error as Error).message || 'Failed to get drivers data' });
	}
});

/**
 * @openapi
 * /manual-reservation:
 *   post:
 *     summary: Make a manual reservation for a vehicle
 *     security:
 *       - ApiKeyAuth: []
 *     tags:
 *       - Vehicle & Driver
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             properties:
 *               registrationCode:
 *                 type: string
 *               time:
 *                 type: string
 *                 format: date-time
 *               location:
 *                 type: string
 *                 enum: ['campus', 'notunbazar', 'sayeednagar']
 *               userType:
 *                 type: string
 *                 enum: ['student', 'teacher', 'staff']
 *               vehicleId:
 *                 type: string
 *     responses:
 *       200:
 *         description: Manual reservation made successfully
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 success:
 *                   type: boolean
 *                 data:
 *                   type: object
 */
router.post('/manual-reservation', async function (req: express.Request, res: express.Response) {
	try {
		const result = await controllers.manualReservation(req);
		res.status(200).json({ success: true, data: result });
	} catch (error) {
		res.status(500).json({ success: false, error: (error as Error).message || 'Failed to make manual reservation' });
	}
});


const indexRoutes = {
	router,
};

export default indexRoutes;
