# Use the official Node.js image as the base image
FROM node:20 as builder

# Set the working directory in the container
WORKDIR /app

# Copy package.json and package-lock.json to the working directory
COPY package*.json ./

# Install dependencies
RUN npm ci

# Copy the rest of the application source code
COPY . .

# Build the application for production
RUN npm run build

# Run tests (optional, can be skipped in production images)
RUN npm test -- --passWithNoTests

# Use a lightweight Node.js image for the production environment
FROM node:20-slim as production

# Set the working directory in the production container
WORKDIR /app

# Copy the build output from the builder stage
COPY --from=builder /app/build ./build

# Copy only necessary files for serving the app
COPY package*.json ./

# Install production dependencies
RUN npm ci --o
