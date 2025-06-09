import swaggerJSDoc from 'swagger-jsdoc';

const options = {
	definition: {
		openapi: '3.0.0',
		info: {
			title: 'DIU Transport API',
			version: '1.3.0',
			description: 'API documentation for DIU Transport App',
		},
		servers: [
			{
				url: '/api/v1',
				description: 'Main API server',
			},
		],
		components: {
			securitySchemes: {
				ApiKeyAuth: {
					type: 'apiKey',
					in: 'header',
					name: 'Authorization'
				}
			}
		},
	},
	apis: ['./routes/*.ts', './controllers/*.ts', './schemas/*.ts'], // Path to the API docs
	customSiteTitle: 'DIU Transport API Docs',
};

const swaggerSpec = swaggerJSDoc(options);

export default swaggerSpec;

