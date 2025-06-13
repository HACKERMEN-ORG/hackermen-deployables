# SourceDirectory Deployables

A comprehensive infrastructure-as-code solution for deploying and managing self-hosted services using Docker, Traefik, and Ansible.

## Overview

This project provides automated deployment and maintenance of essential services required for organizations to collaborate efficiently. It uses Ansible playbooks to orchestrate Docker containers behind a Traefik reverse proxy with automatic SSL certificate management.

## Features

- **Automated Deployment**: Deploy entire infrastructure stacks with a single command
- **Let's Encrypt SSL Automation**: Automatic SSL/TLS certificates with zero-downtime renewal via Traefik ACME integration
- **Multiple SSL Challenge Methods**: HTTP challenge (default) and Cloudflare DNS challenge support
- **Service Discovery**: Dynamic routing with Traefik reverse proxy
- **Modular Architecture**: Easy to add or remove services
- **Production-Ready**: Includes monitoring, backups, and security best practices

## Quick Start

1. Clone the repository:
```bash
git clone https://git.brainiac.gg/bwall/sourcedirectory.git
cd sourcedirectory-deployables
```

2. Set up environment variables:
```bash
# Create .env file with required variables
echo "TRAEFIK_DASHBOARD_CREDENTIALS=admin:$(htpasswd -nb admin your-password | sed -e s/\\$/\\$\\$/g)" >> .env

# Optional: For Cloudflare DNS challenge (recommended for wildcard certificates)
echo "CF_DNS_API_TOKEN=your-cloudflare-api-token" >> .env
```

**SSL Certificate Setup**: By default, Let's Encrypt certificates are automatically obtained via HTTP challenge. For production environments with multiple subdomains, consider using Cloudflare DNS challenge for wildcard certificates.

3. Create Docker network:
```bash
docker network create proxy
```

4. Deploy services:
```bash
ansible-playbook sourcedirectory/playbook.yml
```

## Project Structure

- `/sourcedirectory` - Main deployment directory with services and playbooks
- `/examples` - Example configurations for getting started
- `/local` - Local development setup with self-signed certificates

## Documentation

- [Deployment Guide](sourcedirectory/README.md) - Detailed deployment instructions
- [Development Documentation](DEVDOCS.md) - Architecture and development guidelines
- [CI/CD Setup](sourcedirectory/docker/CI-CD-SETUP.md) - Continuous integration setup

## Available Services

The project includes configurations for:
- **Infrastructure**: Traefik, Portainer, Coolify
- **Development**: Gitea, VS Code Server, Dokku
- **Communication**: Discord bots and dashboards
- **Productivity**: Focalboard, Draw.io, Organizr
- **Monitoring**: Various logging and monitoring solutions

## Contributing

Feel free to submit issues and pull requests. Please follow the existing code structure and documentation style.

## License

This project is open source. Please check individual service licenses for their respective terms.