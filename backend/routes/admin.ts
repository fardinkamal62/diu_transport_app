import express from 'express';

const router = express.Router();

import controllers from '../controllers/admin';
import middlewares from '../middlewares';
import validators from '../validators';

/**
 * @openapi
 * /admin/login:
 *   post:
 *     summary: Admin login
 *     tags:
 *       - Admin
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
router.post('/login', middlewares.validateRequest(validators.adminLoginSchema), async (req: express.Request, res: express.Response) => {
	try {
		const result = await controllers.login(req);
		res.status(200).json({ success: true, data: result });
	} catch (error) {
		res.status(400).json({ success: false, error: (error as Error).message || 'Authentication failed' });
	}
});

router.use(middlewares.adminAuth);

/**
 * @openapi
 * /admin/add-vehicle:
 *   post:
 *     summary: Add a new vehicle
 *     tags:
 *       - Admin
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             properties:
 *               name:
 *                 type: string
 *               type:
 *                 type: string
 *                 enum: [bus, microbus]
 *               vehicleRegistrationNumber:
 *                 type: string
 *               status:
 *                 type: string
 *                 enum: [active, inactive]
 *               reservedSeats:
 *                 type: number
 *               capacity:
 *                 type: number
 *             required:
 *               - name
 *               - type
 *               - vehicleRegistrationNumber
 *               - capacity
 *     responses:
 *       200:
 *         description: Vehicle added successfully
 *       400:
 *         description: Failed to add vehicle
 */
router.post('/add-vehicle', middlewares.validateRequest(validators.addVehicleSchema), async (req: express.Request, res: express.Response) => {
	try {
		const result = await controllers.addVehicle(req);
		res.status(200).json({ success: true, data: result });
	} catch (error) {
		res.status(400).json({ success: false, error: (error as Error).message || 'Failed to add vehicle' });
	}
});

/**
 * @openapi
 * /admin/add-driver:
 *   post:
 *     summary: Add a new driver
 *     tags:
 *       - Admin
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             properties:
 *               name:
 *                 type: string
 *               phoneNumber:
 *                 type: string
 *               password:
 *                 type: string
 *                 format: password
 *               status:
 *                 type: string
 *                 enum: [active, inactive]
 *               preferredVehicle:
 *                 type: array
 *                 items:
 *                   type: string
 *                   enum: [bus, microbus]
 *             required:
 *               - name
 *               - phoneNumber
 *               - password
 *               - preferredVehicle
 *     responses:
 *       200:
 *         description: Driver added successfully
 *       400:
 *         description: Failed to add driver
 */
router.post('/add-driver', middlewares.validateRequest(validators.addDriverSchema), async (req: express.Request, res: express.Response) => {
	try {
		const result = await controllers.addDriver(req);
		res.status(200).json({ success: true, data: result });
	} catch (error) {
		res.status(400).json({ success: false, error: (error as Error).message || 'Failed to add driver' });
	}
});

/**
 * @openapi
 * /admin/update-vehicle/{id}:
 *   put:
 *     summary: Update vehicle details
 *     tags:
 *       - Admin
 *     parameters:
 *       - name: id
 *         in: path
 *         required: true
 *         schema:
 *           type: string
 *           description: Vehicle ID
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             properties:
 *               name:
 *                 type: string
 *               type:
 *                 type: string
 *                 enum: [bus, microbus]
 *               vehicleRegistrationNumber:
 *                 type: string
 *               status:
 *                 type: string
 *                 enum: [active, inactive]
 *               reservedSeats:
 *                 type: number
 *               capacity:
 *                 type: number
 *     responses:
 *       200:
 *         description: Vehicle updated successfully
 *       400:
 *         description: Failed to update vehicle
 */
router.put('/update-vehicle/:id', middlewares.validateRequest(validators.addVehicleSchema), async (req: express.Request, res: express.Response) => {
	try {
		const result = await controllers.updateVehicleData(req);
		res.status(200).json({ success: true, data: result });
	} catch (error) {
		res.status(400).json({ success: false, error: (error as Error).message || 'Failed to update vehicle' });
	}
});

/**
 * @openapi
 * /admin/update-driver/{id}:
 *   put:
 *     summary: Update driver details
 *     tags:
 *       - Admin
 *     parameters:
 *       - name: id
 *         in: path
 *         required: true
 *         schema:
 *           type: string
 *           description: Driver ID
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             properties:
 *               name:
 *                 type: string
 *               phoneNumber:
 *                 type: string
 *               password:
 *                 type: string
 *                 format: password
 *               status:
 *                 type: string
 *                 enum: [active, inactive]
 *               preferredVehicle:
 *                 type: array
 *                 items:
 *                   type: string
 *                   enum: [bus, microbus]
 *     responses:
 *       200:
 *         description: Driver updated successfully
 *       400:
 *         description: Failed to update driver
 */
router.put('/update-driver/:id', middlewares.validateRequest(validators.updateDriverSchema), async (req: express.Request, res: express.Response) => {
	try {
		const result = await controllers.updateDriverData(req);
		res.status(200).json({ success: true, data: result });
	} catch (error) {
		res.status(400).json({ success: false, error: (error as Error).message || 'Failed to update driver' });
	}
});

/**
 * @openapi
 * /admin/delete-vehicle/{id}:
 *   delete:
 *     summary: Delete a vehicle
 *     tags:
 *       - Admin
 *     parameters:
 *       - name: id
 *         in: path
 *         required: true
 *         schema:
 *           type: string
 *           description: Vehicle ID
 *     responses:
 *       200:
 *         description: Vehicle deleted successfully
 *       400:
 *         description: Failed to delete vehicle
 */
router.delete('/delete-vehicle/:id', async (req: express.Request, res: express.Response) => {
	try {
		const result = await controllers.deleteVehicle(req);
		res.status(200).json({ success: true, data: result });
	} catch (error) {
		res.status(400).json({ success: false, error: (error as Error).message || 'Failed to delete vehicle' });
	}
});

/**
 * @openapi
 * /admin/delete-driver/{id}:
 *   delete:
 *     summary: Delete a driver
 *     tags:
 *       - Admin
 *     parameters:
 *       - name: id
 *         in: path
 *         required: true
 *         schema:
 *           type: string
 *           description: Driver ID
 *     responses:
 *       200:
 *         description: Driver deleted successfully
 *       400:
 *         description: Failed to delete driver
 */
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
