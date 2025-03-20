import Joi from 'joi';

const coOrdinateSchema = Joi.object({
	latitude: Joi.number().min(-90).max(90).required(),
	longitude: Joi.number().min(-180).max(180).required(),
});

const schemas = {
	coOrdinateSchema
}

export default schemas;
