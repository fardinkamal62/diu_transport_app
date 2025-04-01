import winston from 'winston';
import fs from 'fs';

// Ensure logs directory exists
const logDir = 'logs';
if (!fs.existsSync(logDir)) {
	fs.mkdirSync(logDir);
}

const logger = winston.createLogger({
	transports: [
		new winston.transports.Console({
			level: 'silly',
			format: winston.format.combine(
				winston.format.colorize({ all: true }),
				winston.format.simple(),
				winston.format.timestamp(),
				winston.format.printf(({ timestamp, level, message }) => {
					return `${timestamp} ${level}: ${message}`;
				}),
			),
		}),
		new winston.transports.File({
			filename: 'logs/app.log',
			level: 'silly',
			format: winston.format.combine(
				winston.format.timestamp(),
				winston.format.printf(({ timestamp, level, message }) => {
					return `${timestamp} ${level}: ${message}`;
				}),
			),
		}),
	],
});

export default logger;
