# -------------------------
# Builder Stage: Build the Vite App
# -------------------------
    FROM node:18 AS build

    # Set working directory
    WORKDIR /app
    
    # Copy package files for efficient caching
    COPY package.json package-lock.json* ./
    
    # Install dependencies
    RUN npm install
    
    # Copy the rest of the project files
    COPY . .
    
    # Build the React app with Vite (this creates the "dist" folder)
    RUN npm run build
    
    # -------------------------
    # Final Stage: Serve with Nginx
    # -------------------------
    FROM nginx:alpine
    
    # Remove default Nginx static assets (optional, if you wish to override the default content)
    RUN rm -rf /usr/share/nginx/html/*
    
    # Copy build files (from the "dist" folder) to Nginx's directory
    COPY --from=build /app/dist /usr/share/nginx/html
    
    # Expose port 80 for serving the app
    EXPOSE 80
    
    # Start Nginx when the container runs
    CMD ["nginx", "-g", "daemon off;"]
    