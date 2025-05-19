import express from 'express';

const router = express.Router();

import controllers from '../controllers/user';
import middlewares from '../middlewares';
import validators from '../validators';

router.post('/login', middlewares.validateRequest(validators.userLoginSchema), async (req: express.Request, res: express.Response) => {
	try {
		const result = await controllers.login(req);
		res.status(200).json({ success: true, data: result });
	} catch (error) {
		res.status(400).json({ success: false, error: (error as Error).message || 'Authentication failed' });
	}
});

router.use(middlewares.userAuth);

const userRoutes = {
	router,
};

export default userRoutes;
