# SourceDirectory Deployment Guide

This directory contains all the service configurations and deployment scripts for the SourceDirectory infrastructure.

## Prerequisites

- Docker and Docker Compose installed
- Ansible installed (for automated deployment)
- A domain name with Cloudflare DNS management
- Basic knowledge of Docker and reverse proxy concepts

## Initial Setup

### 1. Environment Variables

Create a `.env` file in this directory with the following variables:

```bash
# Traefik Dashboard Authentication
# Generate with: htpasswd -nb admin your-password
TRAEFIK_DASHBOARD_CREDENTIALS=admin:$apr1$3fqolv60$K8PEqP851OAEcBuRNYaxU1

# Cloudflare API Token for DNS Challenge
CF_DNS_API_TOKEN=your-cloudflare-api-token
```

### 2. Cloudflare API Token

To create your Cloudflare API token:
1. Log into your Cloudflare account
2. Go to Profile → API Tokens
3. Create a token with permissions: `Zone.Zone, Zone.DNS`
4. Save the token in your `.env` file

### 3. Docker Network

Create the proxy network that all services will use:

```bash
docker network create proxy
```

## Service Configuration

### Docker Compose Template

All services follow this template for Traefik integration:

```yaml
version: "3.8"
services:
  service-name:
    image: example/image:latest
    labels:
      - "traefik.enable=true"
      - "traefik.http.routers.service-name.rule=Host(`subdomain.example.com`)"
      - "traefik.http.routers.service-name.entrypoints=https"
      - "traefik.http.routers.service-name.tls=true"
      - "traefik.http.services.service-name.loadbalancer.server.port=8000"
    networks:
      - proxy

networks:
  proxy:
    external: true
```

## Deployment Methods

### Option 1: Ansible Playbook (Recommended)

Deploy all services automatically:

```bash
ansible-playbook playbook.yml
```

To deploy specific services, edit the playbook or use tags:

```bash
ansible-playbook playbook.yml --tags "traefik,gitea"
```

### Option 2: Manual Docker Compose

Deploy individual services:

```bash
cd docker/service-name/
docker-compose up -d
```

## Available Services

### Core Infrastructure
- **Traefik**: Reverse proxy with automatic SSL
- **Portainer**: Docker management UI
- **Coolify**: Self-hosted Vercel/Netlify alternative

### Development Tools
- **Gitea**: Git repository hosting
- **Dokku**: PaaS for app deployment
- **VS Code Server**: Web-based code editor

### Collaboration
- **Focalboard**: Project management boards
- **Draw.io**: Diagram editor
- **Organizr**: Service dashboard

### Additional Services
See the `docker/` directory for all available service configurations.

## Maintenance

### SSL Certificate Renewal

Certificates are automatically renewed via Traefik's ACME integration. No manual intervention required.

### Backup Strategy

1. Use the daily backup playbook:
```bash
ansible-playbook playbooks/dailybackup-playbook.yml
```

2. Configure automated backups in your cron:
```bash
0 2 * * * /usr/bin/ansible-playbook /path/to/playbooks/dailybackup-playbook.yml
```

### Service Updates

Update all services:
```bash
docker-compose pull
docker-compose up -d
```

## Troubleshooting

### Common Issues

1. **Port Conflicts**: Ensure no other services are using ports 80/443
2. **SSL Issues**: Verify Cloudflare API token permissions
3. **Network Issues**: Confirm the proxy network exists
4. **Service Discovery**: Check Traefik labels in docker-compose files

### Debug Commands

```bash
# Check Traefik logs
docker logs traefik

# Verify service labels
docker inspect service-name | grep -A 20 Labels

# Test DNS resolution
nslookup subdomain.example.com
```

## Security Considerations

- Always use strong passwords for service authentication
- Keep services updated regularly
- Use firewall rules to restrict access where appropriate
- Enable 2FA on critical services when available
- Regular backups are essential

## Support

For issues or questions:
- Check existing configurations in `docker/` directory
- Review Traefik dashboard for routing issues
- Consult service-specific documentation