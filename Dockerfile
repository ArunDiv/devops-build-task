FROM nginx:alpine

# Remove default NGINX config
RUN rm /etc/nginx/conf.d/default.conf

# Copy your custom NGINX config (already SPA-friendly)
COPY nginx.conf /etc/nginx/nginx.conf

# Copy your static build folder directly to NGINX web root
COPY build/ /usr/share/nginx/html/

# Expose the HTTP port
EXPOSE 80

# Health check for orchestration
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD curl -f http://localhost/ || exit 1

# Start NGINX in foreground
CMD ["nginx", "-g", "daemon off;"]

