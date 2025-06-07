# Gitea + Dokku CI/CD Setup Guide

This guide explains how to set up a complete CI/CD pipeline using Gitea and Dokku.

## Architecture Overview

- **Gitea**: Git hosting service with webhook support
- **Dokku**: PaaS platform for deploying applications
- **Webhook Server**: Bridges Gitea webhooks to Dokku deployments
- **Traefik**: Reverse proxy handling SSL and routing

## Prerequisites

1. Docker and Docker Compose installed
2. Traefik proxy network created: `docker network create proxy`
3. Domain names configured:
   - `git.brainiac.gg` → Gitea
   - `dokku.brainiac.gg` → Dokku web UI
   - `webhook.brainiac.gg` → Webhook server

## Installation Steps

### 1. Install Dokku on Host

```bash
cd hackermen/docker/dokku
./install-dokku.sh
```

### 2. Configure SSH Access

Add your SSH key to Dokku:
```bash
cat ~/.ssh/id_rsa.pub | sudo dokku ssh-keys:add admin
```

### 3. Deploy Gitea

```bash
cd hackermen/docker/gitea
docker-compose up -d
```

Access Gitea at https://git.brainiac.gg and complete the initial setup.

### 4. Deploy Dokku Web UI (Optional)

```bash
cd hackermen/docker/dokku
docker-compose up -d
```

### 5. Deploy Webhook Server

First, create an SSH key for the webhook server to access Dokku:
```bash
ssh-keygen -t rsa -b 4096 -f ~/.ssh/dokku-deploy -N ""
cat ~/.ssh/dokku-deploy.pub | sudo dokku ssh-keys:add deploy-bot
```

Then deploy the webhook server:
```bash
cd hackermen/docker/gitea/webhooks
docker-compose up -d
```

## Configuration

### Setting up a Project for CI/CD

1. **Create Dokku App**:
   ```bash
   dokku apps:create myapp
   ```

2. **Configure environment** (if needed):
   ```bash
   dokku config:set myapp KEY=value
   ```

3. **Create Git Repository in Gitea**:
   - Log into Gitea
   - Create new repository
   - Add webhook:
     - URL: `https://webhook.brainiac.gg/webhook`
     - Secret: Same as `WEBHOOK_SECRET` in webhook server
     - Events: Push events

4. **Push to Deploy**:
   ```bash
   git remote add origin https://git.brainiac.gg/username/myapp.git
   git push origin main
   ```

## Workflow

1. Developer pushes code to Gitea
2. Gitea sends webhook to webhook server
3. Webhook server clones repository and pushes to Dokku
4. Dokku builds and deploys the application
5. Application is accessible at `myapp.brainiac.gg`

## Security Considerations

1. **Webhook Secret**: Always use a strong webhook secret
2. **SSH Keys**: Keep deployment SSH keys secure
3. **Network Isolation**: Consider isolating CI/CD components
4. **HTTPS**: All services use HTTPS via Traefik

## Troubleshooting

### Check webhook server logs:
```bash
docker logs gitea-webhook-server
```

### Check Dokku deployment logs:
```bash
dokku logs myapp
```

### Verify Dokku app status:
```bash
dokku ps:report myapp
```

## Advanced Configuration

### Database Services

Add PostgreSQL to your app:
```bash
dokku postgres:create myapp-db
dokku postgres:link myapp-db myapp
```

### Custom Domains

```bash
dokku domains:add myapp myapp.brainiac.gg
```

### SSL with Traefik

Apps deployed through Dokku can be exposed through Traefik by:
1. Setting up Docker labels on Dokku containers
2. Or using Dokku's nginx and configuring upstream to Traefik