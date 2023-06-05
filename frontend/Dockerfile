# Use the official Nginx base image
FROM nginx:latest

# Remove default Nginx configuration file
# RUN rm /etc/nginx/conf.d/default.conf

# Copy custom Nginx configuration file
# COPY nginx.conf /etc/nginx/conf.d/

# Copy your application files to the Nginx document root directory
COPY index.html /usr/share/nginx/html

# Expose port 80 for incoming HTTP traffic
EXPOSE 80

# Start Nginx server
CMD ["nginx", "-g", "daemon off;"]
