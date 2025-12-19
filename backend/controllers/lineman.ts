import { Request } from 'express';

import api from '../api/v1/lineman';

const login = (req: Request) : Promise<object> => {
	return api.login(req);
};

export default { login };
