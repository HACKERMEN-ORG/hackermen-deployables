# Coolify Setup

Coolify is a self-hosted alternative to Heroku, Netlify, and Vercel. It provides an easy-to-use interface for deploying applications, databases, and services.

## Features

- Deploy applications from Git repositories
- Built-in database support (PostgreSQL, MySQL, Redis, etc.)
- Automatic SSL certificates via Let's Encrypt
- Docker and Docker Compose support
- Real-time deployments and monitoring
- Team collaboration features

## Quick Start

1. **Start Coolify**:
   ```bash
   docker-compose up -d
   ```

2. **Access Coolify**:
   - Web Interface: https://coolify.brainiac.gg
   - Proxy Dashboard: https://coolify-proxy.brainiac.gg

3. **Initial Setup**:
   - Complete the web-based setup wizard
   - Configure your first server (localhost)
   - Add your Git repositories

## Configuration

### Environment Variables
The `.env` file contains all necessary configuration. Key variables:

- `APP_KEY`: Laravel application key (already generated)
- `DB_PASSWORD`: PostgreSQL database password
- `REDIS_PASSWORD`: Redis cache password
- `PUSHER_*`: Real-time notification settings

### Custom Domains
To use a custom domain, update the `.env` file:
```bash
APP_URL=https://coolify.yourdomain.com
```

Then update the Traefik labels in `docker-compose.yml`.

## Architecture

### Services
- **coolify**: Main application (Laravel-based)
- **postgres**: Database for Coolify data
- **redis**: Cache and session storage
- **coolify-proxy**: Traefik proxy for deployed applications

### Networks
- **proxy**: External network for main Traefik integration
- **coolify**: Internal network for Coolify services
- **coolify-proxy**: Network for applications deployed by Coolify

### Volumes
- `coolify_data`: Main application data
- `coolify_ssh`: SSH keys for Git access
- `coolify_applications`: Deployed application data
- `coolify_backups`: Application backups
- `postgres_data`: Database storage
- `redis_data`: Cache storage

## Deploying Applications

### Via Web Interface
1. Go to https://coolify.brainiac.gg
2. Add a new project
3. Connect your Git repository
4. Configure build settings
5. Deploy!

### Supported Application Types
- Static sites (HTML, React, Vue, etc.)
- Node.js applications
- PHP applications (Laravel, WordPress)
- Python applications (Django, Flask)
- Docker-based applications
- Docker Compose applications

## Integration with Gitea

Coolify can integrate with your Gitea instance:

1. In Coolify, add Gitea as a Git source
2. Use webhook URL: `https://coolify.brainiac.gg/webhooks/gitea`
3. Configure automatic deployments on push

## Database Services

Coolify can deploy and manage databases:
- PostgreSQL
- MySQL
- Redis
- MongoDB
- MinIO (S3-compatible storage)

## Backup and Restore

Coolify includes built-in backup functionality:
- Automatic database backups
- Application file backups
- S3-compatible storage support

## Monitoring

Access logs and metrics:
```bash
# View Coolify logs
docker logs coolify

# View specific application logs
docker logs <app-container-name>

# Access database
docker exec -it coolify-postgres psql -U coolify -d coolify
```

## Troubleshooting

### Common Issues

1. **Port conflicts**: Ensure ports 8080 and 8443 are available
2. **Docker socket permission**: Coolify needs access to Docker socket
3. **SSL certificates**: Let's Encrypt requires valid DNS records

### Reset Coolify
```bash
docker-compose down -v
docker-compose up -d
```

## Security Notes

- Change default passwords in `.env`
- Use strong APP_KEY (already generated)
- Configure firewall rules appropriately
- Regular backups recommended

## Updating Coolify

```bash
docker-compose pull
docker-compose up -d
```

## Support

- Official Documentation: https://coolify.io/docs
- GitHub: https://github.com/coollabsio/coolify
- Discord: https://coollabs.io/discord