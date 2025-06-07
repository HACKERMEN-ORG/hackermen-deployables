# Dokku Container Setup

This directory contains the containerized version of Dokku that integrates with the Gitea CI/CD pipeline.

## Setup Instructions

1. **Add SSH Keys**: Place your public SSH keys in the `ssh-keys/` directory:
   ```bash
   cp ~/.ssh/id_rsa.pub ./ssh-keys/
   ```

2. **Start Dokku Container**:
   ```bash
   docker-compose up -d
   ```

3. **Access Dokku**: 
   - Dashboard: https://dokku.brainiac.gg
   - SSH: `ssh -p 2222 dokku@dokku.brainiac.gg`

## Gitea Integration

The webhook server in `../gitea/webhooks/` is configured to deploy to this containerized Dokku instance.

### Deploy from Gitea:
1. Add webhook in Gitea pointing to: `https://webhook.brainiac.gg/deploy`
2. Git remote: `ssh://dokku@dokku.brainiac.gg:2222/appname`

## Managing Apps

```bash
# Create an app
docker exec dokku dokku apps:create myapp

# Link a database
docker exec dokku dokku postgres:create myapp-db
docker exec dokku dokku postgres:link myapp-db myapp

# Set environment variables
docker exec dokku dokku config:set myapp KEY=value

# View logs
docker exec dokku dokku logs myapp
```

## Deployed Apps

Apps will be accessible at: `https://appname.dokku.brainiac.gg`