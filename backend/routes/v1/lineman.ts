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

const linemanRoutes = {
	router,
};

export default linemanRoutes;