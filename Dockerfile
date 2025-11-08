# Use a lightweight web server (Nginx)
FROM nginx:alpine
# Copy your game files into the web root
COPY . /usr/share/nginx/html
# The game will be served on port 80
EXPOSE 80
