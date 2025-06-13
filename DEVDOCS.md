#### Mission
create a community of like minded technical individuals with the infrastructure in place to collaborate efficiently

#### Process
Use Ansible to automate the deployment and long term support of required infrastructure.
The Ansible playbook will use Docker for containerization and Traefik as the dynamic reverse proxy
All essential services will be deployed with docker-compose within the playbook.
Essential services are the bare minimum resources required for an organization to operation.
These include communications such as email, instant messaging, forum based threads, and infrastructure services such as VM and container orchestration, shared drives, and various groupware etc.
After deployment, ease of migration and data redundancy is essential to ensure smooth transition between hosts and ensure permanence of the project and long term support using automated playbooks.

#### Current Objective

#### Automate the deployment of the following using Ansible
 Essential Services

    Infrastructure
        Docker - containerization
        Traefik - dynamic reverse proxy
        OpenVPN - VPN servers, maybe WireGuard?
        Proxmox VE - connect to nodes and provide VMs
        Portainer - allow deployment of docker containers
        TBD - Cloud storage service, NextCloud?
        TBD - nightly backups (Tarsnap? Rsnapshot?)
        Security - determine services for logging and 
    
    Development
        Gitea - git server
        Code-Server - vscode web client
        Wiki - determine wiki for more elaborate projects
        Clearflask - user feedback and dev road map?

    Communication
        Mailu - mail server with roundcube webmail client
        Synapse - matrix server with web client (TBD)
        myBB - Community forum
        FreshRSS - rss reader for relevant news

    Groupware
        FocalBoard - open to better alternatives
        BitWarden - password manager for shared services
        Cryptpad - E2EE office suite
        Draw.io - diagram editor
        BitPoll / Framadate - group event scheduler

    Finances
        BigCapital - Accounting suite
        BTCPay - Bitcoin payment processor
    
    Requested Services:
        TBD - shortlink maker
        PenPot - ui design tool
        OctaveOnline - MATLAB alternative
        Bracket - tournament bracket generator
        Searx - search engine

    Noteable Services:
        MyPaaS - docker and traefik automated deployment (captnbp/mypaas)
        PikaPod - deploy self hosted services
        VirtKick - VPS admin panel with billing
        Virtualmin - VPS admin panel
        Cloudron
        Coolify - Vercel clone
        Paperless - document scanner 
        Privatebin - encrypted pastebin
        Flashpaper - one time encrypted secret share

    Basic services
        pass (unix program) password manager
        RSS feed client server
        web page deployment

#### How to use ansible
Ensure public ssh keys are located on clients
`ssh-copy-id -i YOUR PRIVATE KEY`

To run as local host configure yaml config:
`hosts: <your host> # eg. localhost`

Make docker network proxy
`docker network create proxy`

To run the playbook in your current directory
`ansible-playbook <the configuration you want to run>.yml # etc.`

Add and remove stuff from the playbook as needed to get ansible-playbook to work.

DEPLOY!!!

## SSL/TLS Management

### Modern Approach: Traefik + Let's Encrypt ACME

The project now uses Traefik's built-in ACME client for automatic SSL certificate management, eliminating the need for manual Certbot integration.

**Benefits:**
- Zero-downtime certificate renewal
- Automatic certificate provisioning for new services
- No need to stop/restart Docker containers
- Built-in support for multiple challenge types

**Configuration:**
- HTTP Challenge: Default, works with any DNS provider
- DNS Challenge: Cloudflare integration for wildcard certificates

**Key Files:**
- `data/traefik.yml`: ACME configuration
- `data/acme.json`: Certificate storage (must be chmod 600)

### Legacy Certbot Approach (Deprecated)

The old manual Certbot approach is no longer recommended:

```bash
# OLD METHOD - DO NOT USE
#!/bin/sh
docker kill $(docker ps)
systemctl stop docker
certbot renew
systemctl restart docker
```

**Why this is problematic:**
- Causes service downtime during renewal
- Requires manual intervention
- Prone to automation failures
- Complex coordination with Docker

### Migration from Certbot

If migrating from a Certbot setup:
1. Stop any existing Certbot renewal cron jobs
2. Remove manual certificate mounts from docker-compose files
3. Configure Traefik ACME as documented in the deployment guide
4. Let Traefik handle all certificate operations

### SSL Best Practices

- Use strong TLS configurations (TLS 1.2+ only)
- Enable HSTS headers where appropriate
- Regular certificate monitoring and alerting
- Backup `acme.json` as part of disaster recovery
- Monitor Let's Encrypt rate limits for production environments
