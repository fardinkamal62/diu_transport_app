import express from 'express';

const router = express.Router();

import controllers from '../../controllers/user';
import middlewares from '../../middlewares';
import validators from '../../validators';

/**	@openapi
 * /user/login:
 *   post:
 *     summary: User login endpoint
 *     tags:
 *       - User
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *          schema:
 *           type: object
 *           required:
 *            - email
 *            - password
 *           properties:
 *            email:
 *             type: string
 *            password:
 *             type: string
 *     responses:
 *       200:
 *         description: User logged in successfully
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 success:
 *                   type: boolean
 *                 data:
 *                   type: object
 *                   properties:
 *                     token:
 *                       type: string
 *                     user:
 *                       type: object
 *                       properties:
 *                         id:
 *                           type: string
 *                         name:
 *                           type: string
 *                         email:
 *                           type: string
 *                         slug_name:
 *                           type: string
 *                         reg_code:
 *                           type: string
 *                         profile_photo:
 *                           type: string
 *                         blood_status:
 *                           type: string
 *       400:
 *         description: Authentication failed
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 success:
 *                   type: boolean
 *                 message:
 *                   type: string
 *                 details:
 *                   type: array
 *                   items:
 *                     type: string
 *               example:
 *                 success: false
 *                 error: 'Validation Error'
 *                 details:
 *                   - 'Username is required'
 *                   - 'Password is required'
 *       500:
 *         description: Internal server error
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 success:
 *                   type: boolean
 *                 error:
 *                   type: string
 *               example:
 *                 success: false
 *                 error: 'Internal server error'
 */

router.post('/login', middlewares.validateRequest(validators.userLoginSchema), async (req: express.Request, res: express.Response) => {
	try {
		const result = await controllers.login(req);
		res.status(200).json({ success: true, data: result });
	} catch (error) {
		res.status(400).json({ success: false, error: (error as Error).message || 'Authentication failed' });
	}
});

router.use(middlewares.userAuth);
/** @openapi
 * /user/reservation:
 *   post:
 *     summary: Create a new reservation
 *     tags:
 *       - Reservation
 *     security:
 *       - ApiKeyAuth: []
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             required:
 *               - registrationCode
 *               - time
 *               - location
 *               - userType
 *             properties:
 *               registrationCode:
 *                 type: string
 *                 description: Unique registration code for the reservation
 *               time:
 *                 type: string
 *                 format: date-time
 *                 description: Time of the reservation
 *               location:
 *                 type: string
 *                 enum:
 *                   - campus
 *                   - notunbazar
 *                   - sayeednagar
 *                 description: Location of the reservation
 *               userType:
 *                 type: string
 *                 enum:
 *                   - student
 *                   - teacher
 *                   - staff
 *                 description: Type of user making the reservation
 *     responses:
 *       200:
 *         description: Reservation created successfully
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 success:
 *                   type: boolean
 *                 data:
 *                   type: object
 *                   properties:
 *                     id:
 *                       type: string
 *                     registrationCode:
 *                       type: string
 *                     time:
 *                       type: string
 *                       format: date-time
 *                     location:
 *                       type: string
 *                     userType:
 *                       type: string
 *                     status:
 *                       type: string
 *                       enum:
 *                         - scheduled
 *                         - cancelled
 *                         - completed
 *                         - onboard
 *       400:
 *         description: Validation error or failed to create reservation
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 success:
 *                   type: boolean
 *                 error:
 *                   type: string
 *       500:
 *         description: Internal server error
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 success:
 *                   type: boolean
 *                 error:
 *                   type: string
 */
router.post('/reservation', middlewares.validateRequest(validators.addReservationSchema), async (req: express.Request, res: express.Response) => {
	try {
		const result = await controllers.addReservation(req);
		res.status(200).json({ success: true, data: result });
	} catch (error) {
		res.status(400).json({ success: false, error: (error as Error).message || 'Failed to add reservation' });
	}
});

/** @openapi
 * /user/reservation:
 *   get:
 *     summary: Retrieve reservations
 *     tags:
 *       - Reservation
 *     security:
 *       - ApiKeyAuth: []
 *     parameters:
 *       - in: query
 *         name: registrationCode
 *         required: true
 *         schema:
 *           type: string
 *         description: Registration code to filter reservations
 *     responses:
 *       200:
 *         description: Reservations retrieved successfully
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
 *                     properties:
 *                       id:
 *                         type: string
 *                       registrationCode:
 *                         type: string
 *                       time:
 *                         type: string
 *                         format: date-time
 *                       location:
 *                         type: string
 *                       userType:
 *                         type: string
 *                       status:
 *                         type: string
 *                         enum:
 *                           - scheduled
 *                           - cancelled
 *                           - completed
 *                           - onboard
 *       400:
 *         description: Validation error or failed to retrieve reservations
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 success:
 *                   type: boolean
 *                 error:
 *                   type: string
 *       500:
 *         description: Internal server error
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 success:
 *                   type: boolean
 *                 error:
 *                   type: string
 */
router.get('/reservation', async (req: express.Request, res: express.Response) => {
	try {
		const result = await controllers.getReservations(req);
		res.status(200).json({ success: true, data: result });
	} catch (error) {
		res.status(400).json({ success: false, error: (error as Error).message || 'Failed to add reservation' });
	}
})


const userRoutes = {
	router,
};

export default userRoutes;
