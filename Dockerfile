# Use a small, production-ready web server
FROM nginx:alpine

# Remove default nginx static content
RUN rm -rf /usr/share/nginx/html/*

# Copy your site into Nginx's web root
COPY . /usr/share/nginx/html

# Expose port 80 for HTTP
EXPOSE 80

# Nginx starts automatically via the base image's CMD
