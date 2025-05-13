#!/bin/bash

# Discord Dashboard Docker-Based Deployment Script
# This script will build everything using Docker, avoiding local Node.js dependencies

# Exit on error
set -e

# Check if .env exists
if [ ! -f ./backend/.env ]; then
  echo "Error: backend/.env file not found. Copy backend/.env.example to backend/.env and update with your values."
  exit 1
fi

# Directory paths
CLIENT_DIR="/home/user/Documents/DiscordBot/dashboard/client"
SERVER_DIR="/home/user/Documents/DiscordBot/dashboard/server"
FRONTEND_DIR="./frontend"
BACKEND_DIR="./backend"

# Ensure directories exist
mkdir -p "$FRONTEND_DIR"
mkdir -p "$BACKEND_DIR"
mkdir -p "./mongodb/data"

# Copy the server code
echo "Copying server code to deployment directory..."
# Use cp instead of rsync
find "$SERVER_DIR" -type f -not -path "*/node_modules/*" -not -path "*/\.*" -exec cp --parents {} "$BACKEND_DIR/" \;

# Run the build container using pre-created docker-compose.build.yml
echo "Building React frontend using Docker..."
mkdir -p "$FRONTEND_DIR/build"
docker-compose -f docker-compose.build.yml up --build react-builder

# Edit the docker-compose.yml to use the pre-built frontend
sed -i 's/#\s*image: nginx:alpine/image: nginx:alpine/' docker-compose.yml
sed -i 's/build:/# build:/' docker-compose.yml
sed -i 's/context/# context/' docker-compose.yml
sed -i 's/dockerfile/# dockerfile/' docker-compose.yml

# Deploy with Docker Compose
echo "Starting Docker services..."
docker-compose up -d

echo "Deployment complete! Your dashboard should be available at https://dashboard.\${DOMAIN}"