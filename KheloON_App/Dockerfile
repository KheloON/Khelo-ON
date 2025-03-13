# Use Flutter base image
FROM cirrusci/flutter:3.13.0 AS build


# Set working directory
WORKDIR /app

# Copy project files
COPY . .

# Enable Flutter Web
RUN flutter config --enable-web

# Get dependencies
RUN flutter pub get

# Build the Flutter app (for web)
RUN flutter build web --release

# Use Nginx for serving static files
FROM nginx:alpine

# Copy Flutter build output to Nginx
COPY --from=build /app/build/web /usr/share/nginx/html

# Expose port
EXPOSE 80

# Start Nginx
CMD ["nginx", "-g", "daemon off;"]