# Use ARM-compatible base image
FROM --platform=linux/arm64 node:18-alpine

# Set working directory
WORKDIR /app

# Copy package files and install dependencies
COPY package*.json ./
RUN npm install

# Copy app source
COPY . .

# Expose the app port
EXPOSE 3000

# Start the app
CMD ["node", "index.js"]