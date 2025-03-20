import colors from 'colors';
import mongoose from 'mongoose';
import * as process from 'node:process';

const init = async (mongoUri: string) : Promise<void> => {
	try {
		if (mongoUri) {
			await mongoose.connect(mongoUri, {
				connectTimeoutMS: 5000,
				socketTimeoutMS: 45000,
				maxPoolSize: 50,
				retryWrites: true,
			});
			console.log(colors.green('Connected to MongoDB'));
		} else {
			console.error(colors.red('No URI provided'));
			process.exit(1);
		}
	} catch (error) {
		console.error(colors.red('Failed to connect to MongoDB'), error);
		process.exit(1);
	}
};

const close = async (): Promise<void> => {
	try {
		console.log(colors.yellow('Closing MongoDB connection...'));
		await mongoose.connection.close();
		console.log(colors.green('Closed MongoDB connection'));
	} catch (error) {
		console.error(colors.red('Failed to close MongoDB connection:'), error);
		throw error;
	}
};

const mongo = {
	init,
	close,
};

export default mongo;
