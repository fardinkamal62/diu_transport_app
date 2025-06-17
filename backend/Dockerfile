FROM node:23.8.0-alpine AS base

WORKDIR /app

# Install dependencies only from package.json and package-lock.json
COPY package.json package-lock.json ./
RUN npm ci

# Copy the rest of the application code
COPY . .

# Build TypeScript code
RUN npx tsc

# Use a minimal image for running the app
FROM node:23.8.0-alpine AS production
WORKDIR /app
COPY --from=base /app/package.json ./
COPY --from=base /app/node_modules ./node_modules
COPY --from=base /app/dist ./dist

# Expose the port (change if your app uses a different port)
EXPOSE 3000

# Start the app
CMD ["node", "dist/index.js"]

