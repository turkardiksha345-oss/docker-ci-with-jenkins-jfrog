# Simple Dockerfile for CI Pipeline
FROM node:18-alpine

WORKDIR /app

# Copy dependency files
COPY app/package*.json ./

# Install dependencies
RUN npm ci --omit=dev

# Copy app source
COPY app/ .

# Create non-root user
RUN addgroup -S appgroup && adduser -S appuser -G appgroup
USER appuser

# Expose app port (optional)
EXPOSE 3000

# Start app
CMD ["npm", "start"]