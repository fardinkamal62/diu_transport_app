# DIU Transport App Backend

This is the backend for the [Dhaka International University](https://diu.ac) Transport App. It is written in TypeScript and uses the Express.js framework.

Redis is used for caching and real-time data processing and MongoDB is used for storing data.

## Technologies

- TypeScript
- Express.js
- MongoDB
- Redis

## Installation

**Install dependencies**

Change to the `backend` directory:

```bash
cd backend
```

Then, install the dependencies:

```bash
npm install
```

## Start the server

One-liner

```bash
bash -c 'redis-server & cd backend && npm run start'
```

Or, step-by-step

Run the Redis server in one terminal
```bash
redis-server
```

Start the Express server in another terminal
```bash
cd backend
npm run start
```

Press `Ctrl + C` to stop the server both Redis and Express server.
