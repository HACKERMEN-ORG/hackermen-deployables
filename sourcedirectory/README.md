# SourceDirectory Deployment Guide

This directory contains all the service configurations and deployment scripts for the SourceDirectory infrastructure.

## Prerequisites

- Docker and Docker Compose installed
- Ansible installed (for automated deployment)
- A domain name with DNS access (Cloudflare recommended for advanced features)
- Port 80 and 443 available for Let's Encrypt SSL certificate validation
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

### 2. SSL Certificate Configuration

**Let's Encrypt with HTTP Challenge (Default)**

The default configuration uses Let's Encrypt HTTP challenge, which works out-of-the-box with any domain provider:

- Certificates are automatically obtained when services start
- Automatic renewal every 90 days
- Requires ports 80 and 443 to be accessible from the internet
- Each subdomain gets its own certificate

**Let's Encrypt with Cloudflare DNS Challenge (Advanced)**

For wildcard certificates or when HTTP challenge isn't feasible:

1. Log into your Cloudflare account
2. Go to Profile → API Tokens
3. Create a token with permissions: `Zone.Zone, Zone.DNS`
4. Update your `.env` file with the token
5. Uncomment the Cloudflare configuration in `docker-compose.yml`

```bash
# In your .env file
CF_DNS_API_TOKEN=your-cloudflare-api-token
```

**Benefits of DNS Challenge:**
- Works behind firewalls/NAT
- Supports wildcard certificates (*.example.com)
- No need for public HTTP access during certificate generation

### 3. Docker Network

Create the proxy network that all services will use:

```bash
docker network create proxy
```

### 4. SSL Certificate Storage

Ensure the ACME certificate storage file exists and has proper permissions:

```bash
# Create the certificate storage file
touch ./data/acme.json
chmod 600 ./data/acme.json
```

**Important**: The `acme.json` file stores your Let's Encrypt certificates. Back this file up regularly and ensure it's not publicly accessible.

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

### SSL Certificate Management

**Automatic Renewal**
- Let's Encrypt certificates are automatically renewed by Traefik
- Renewal occurs when certificates are within 30 days of expiration
- Zero-downtime renewal process
- No manual intervention required

**Certificate Monitoring**
- Check certificate status in Traefik dashboard: `https://traefik.yourdomain.com`
- Verify certificate expiration: `openssl s_client -connect yourdomain.com:443 | openssl x509 -noout -dates`
- Monitor Traefik logs: `docker logs traefik`

**Troubleshooting SSL Issues**
- Ensure ports 80/443 are accessible for HTTP challenge
- Verify DNS records point to your server
- Check Traefik configuration in `data/traefik.yml`
- Review Let's Encrypt rate limits if requests fail

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
2. **SSL Certificate Issues**: 
   - Verify domain DNS points to your server
   - Check Let's Encrypt rate limits (50 certificates per week per domain)
   - Ensure `acme.json` has correct permissions (600)
   - For Cloudflare DNS challenge: verify API token permissions
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