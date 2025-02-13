# FROM nginx:alpine
# COPY lmsproject.html /usr/share/nginx/html/index.html
# COPY lmsproject.css /usr/share/nginx/html/index.html
# EXPOSE 80

# Use NGINX as the base image
FROM nginx:stable-alpine

# Remove default NGINX static files and copy our HTML & CSS files
RUN rm -rf /usr/share/nginx/html/*

# Copy the project files into NGINX's serving directory
COPY . /usr/share/nginx/html

# Expose port 80
EXPOSE 80

# Start NGINX
CMD ["nginx", "-g", "daemon off;"]
