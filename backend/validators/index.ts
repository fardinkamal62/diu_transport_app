import Joi from 'joi';

const MAX_EMAIL_LENGTH = 100;
const coOrdinateSchema = Joi.object({
	latitude: Joi.number().min(-90).max(90).required(),
	longitude: Joi.number().min(-180).max(180).required(),
	vehicleId: Joi.string().hex().length(24).required(),
});

const loginSchema = Joi.object({
	email: Joi.string().max(MAX_EMAIL_LENGTH).email(),
	username: Joi.string().min(2).max(100),
	password: Joi.string()
		.min(8)
		.max(100)
		.pattern(/^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]+$/)
		.messages({
			'string.pattern.base': 'Password must contain at least one uppercase letter, one lowercase letter, one number and one special character'
		})
		.required(),
}).xor('email', 'username');


const addVehicleSchema = Joi.object({
	name: Joi.string().min(2).max(100).required(),
	type: Joi.string().valid('bus', 'microbus').required(),
	vehicleRegistrationNumber: Joi.string().min(2).max(100).required(),
	status: Joi.string().valid('active', 'inactive').default('inactive'),
});

const addDriverSchema = Joi.object({
	name: Joi.string().min(2).max(100).required(),
	phoneNumber: Joi.string().min(10).max(15).pattern(/^[0-9]+$/).required(),
	password: Joi.string()
		.min(8)
		.max(100)
		.required(),
});

const schemas = {
	coOrdinateSchema,
	loginSchema,
	addVehicleSchema,
	addDriverSchema,
}

export default schemas;
