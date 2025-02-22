# Use Node.js as base image
FROM node:18 AS build

# Set working directory
WORKDIR /app

# Copy package files first for efficient caching
COPY package.json package-lock.json ./

# Install dependencies
RUN npm install

# Copy rest of the project
COPY . .

# Build React app
RUN npm run build

# Use Nginx for serving static files
FROM nginx:alpine

# Copy build files to Nginx
COPY --from=build /app/build /usr/share/nginx/html

# Expose port
EXPOSE 80

# Start Nginx
CMD ["nginx", "-g", "daemon off;"]