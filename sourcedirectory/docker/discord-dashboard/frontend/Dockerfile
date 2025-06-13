FROM node:20-alpine as build

WORKDIR /app

# Copy source code (we'll mount it as a volume instead)
# This is just a placeholder - the actual source will be mounted at runtime

# Build the app
RUN npm run build

# Production stage
FROM nginx:alpine

# Copy build output from build stage
COPY --from=build /app/build /usr/share/nginx/html

# Copy nginx configuration
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Expose port
EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]