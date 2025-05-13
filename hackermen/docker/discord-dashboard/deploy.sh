#!/bin/bash

# Discord Dashboard Deployment Script
# This script will build the React app and deploy the dashboard

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
mkdir -p "$FRONTEND_DIR/build"
mkdir -p "$BACKEND_DIR"
mkdir -p "./mongodb/data"

# Build the React app
echo "Building React frontend..."
cd "$CLIENT_DIR"
# Check if node_modules exists, reinstall if needed
if [ ! -d "node_modules" ] || [ ! -f "node_modules/.bin/react-scripts" ]; then
  echo "Installing dependencies first..."
  npm install
fi

# Try to build, if it fails due to module issues, clean and reinstall
if ! npm run build; then
  echo "Build failed, trying to clean and reinstall..."
  rm -rf node_modules
  npm cache clean --force
  npm install
  npm run build
fi
cd -

# Copy the React build to frontend/build
echo "Copying React build to deployment directory..."
mkdir -p "$FRONTEND_DIR/build"
if [ -d "$CLIENT_DIR/build" ] && [ "$(ls -A "$CLIENT_DIR/build")" ]; then
  cp -r "$CLIENT_DIR/build/"* "$FRONTEND_DIR/build/"
else
  echo "Error: React build directory is empty or not found"
  exit 1
fi

# Copy the server code
echo "Copying server code to deployment directory..."
# Use cp instead of rsync
find "$SERVER_DIR" -type f -not -path "*/node_modules/*" -not -path "*/\.*" -exec cp --parents {} "$BACKEND_DIR/" \;

# Deploy with Docker Compose
echo "Starting Docker services..."
docker-compose up -d

echo "Deployment complete! Your dashboard should be available at https://dashboard.\${DOMAIN}"