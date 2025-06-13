# Discord Bot Dashboard Deployment

This directory contains the Docker Compose configuration for deploying the Discord Bot Dashboard with Traefik.

## Prerequisites

- Docker and Docker Compose installed
- Traefik already set up with the sourcedirectory-deployables project
- Discord bot configured with OAuth2 credentials

## Setup Instructions

1. **Create Environment Files**

   Copy the example environment file and adjust the settings:

   ```bash
   cp backend/.env.example backend/.env
   ```

   Edit the `.env` file to include your Discord application credentials and other settings.

2. **Configure Domains**

   Make sure your domain is properly configured in the main `.env` file at the root of the sourcedirectory-deployables project.

3. **Copy Your Build or Deploy from Source**

   You can either:
   
   - Use the `deploy.sh` script to build and deploy from source (recommended)
   - Manually copy your pre-built React app to `frontend/build/`

4. **Deploy Using Docker Compose**

   ```bash
   # Option 1: Using the regular deployment script (requires Node.js on host)
   ./deploy.sh
   
   # Option 2: Using Docker for building (avoids Node.js compatibility issues)
   ./docker-deploy.sh
   
   # Option 3: Manually with pre-built files
   docker-compose up -d
   ```
   
   If you're experiencing Node.js compatibility issues, Option 2 is recommended as it uses Docker to build the React application.

## Directory Structure

```
discord-dashboard/
├── backend/
│   ├── Dockerfile
│   ├── Dockerfile.dev
│   └── .env (created from .env.example)
├── frontend/
│   ├── build/ (React app build)
│   └── nginx.conf
├── mongodb/
│   └── data/ (MongoDB data volume)
├── docker-compose.yml
├── docker-compose.override.yml.example
├── deploy.sh
└── README.md
```

## Development Mode

For development, you can create a `docker-compose.override.yml` file from the example:

```bash
cp docker-compose.override.yml.example docker-compose.override.yml
```

This will:
- Mount your source code directories
- Use hot-reloading for development
- Expose additional ports for debugging

## Connecting to MongoDB

The MongoDB instance is not exposed to the internet by default. To connect to it:

1. Connect through the Docker network
2. Use the connection string: `mongodb://${MONGO_USER}:${MONGO_PASSWORD}@discord-dashboard-mongodb:27017/discord_bot?authSource=discord_bot`

## Troubleshooting

- Check logs with `docker-compose logs -f`
- Ensure the proxy network exists (`docker network ls`)
- Verify Traefik is running and properly configured
- Check CORS settings if you have API connection issues