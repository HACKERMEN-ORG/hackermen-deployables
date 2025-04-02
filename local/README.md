Quick Start

Clone this repository

bashCopygit clone https://github.com/your-username/hackermen-deployables.git
cd hackermen-deployables/hackermen

Create a .env file with your configuration

bashCopycp .env.example .env
# Edit .env with your settings
nano .env

Generate SSL certificates

bashCopychmod +x generate-certs.sh
./generate-certs.sh

Deploy services

bashCopy# Create the proxy network
docker network create proxy

# Start Traefik
docker-compose up -d

# Deploy individual services
cd docker/focalboard
docker-compose up -d
cd ../..
# Continue with other services
Detailed Setup Guide
1. Environment Configuration
Edit the .env file to customize your deployment:
CopyDOMAIN=local
HOSTNAME=192.168.1.x  # Your server's IP address
EMAIL=your.email@example.com
CERT_RESOLVER=selfsigned
TRAEFIK_USER=admin
TRAEFIK_PASSWORD_HASH=$2y$10$zi5n43jq9S63gBqSJwHTH.nCai2vB0SW/ABPGg2jSGmJBVRo0A.ni

# Subdomains for services
TRAEFIK=traefik
FOCALBOARD=board
DOCKGE=dock
GITEA=git
# Add more services here
2. SSL Certificate Setup
Generate self-signed certificates for local deployment:
bashCopy./generate-certs.sh
This creates certificates in ./data/certs/ and configures Traefik to use them.
3. DNS Configuration
Option 1: Using Pi-hole or similar DNS server
Add local domain records to your DNS server's configuration:
Copyaddress=/traefik.local/192.168.1.x
address=/board.local/192.168.1.x
address=/git.local/192.168.1.x
# Add more service entries as needed
Option 2: Using hosts files on client machines
Add to /etc/hosts (Linux/Mac) or C:\Windows\System32\drivers\etc\hosts (Windows):
Copy192.168.1.x traefik.local board.local git.local dock.local
4. Traefik Configuration
The main docker-compose.yml sets up Traefik as the reverse proxy:
yamlCopyversion: "3.8"

services:
  traefik:
    image: traefik:v2.10
    container_name: traefik
    restart: unless-stopped
    security_opt:
      - no-new-privileges:true
    networks:
      - proxy
    ports:
      - 80:80
      - 443:443
    environment:
      TRAEFIK_DASHBOARD_CREDENTIALS: ${TRAEFIK_USER}:${TRAEFIK_PASSWORD_HASH}
    env_file: .env
    volumes:
      - /etc/localtime:/etc/localtime:ro
      - /var/run/docker.sock:/var/run/docker.sock:ro
      - ./data/traefik.yml:/traefik.yml:ro
      - ./data/acme.json:/acme.json
      - ./data/config.yml:/config.yml:ro
      - ./data/certs:/certs:ro
    labels:
      - "traefik.enable=true"
      - "traefik.http.routers.traefik-http.rule=Host(`traefik.local`)"
      - "traefik.http.routers.traefik-http.entrypoints=http"
      - "traefik.http.middlewares.traefik-auth.basicauth.users=${TRAEFIK_USER}:${TRAEFIK_PASSWORD_HASH}"
      - "traefik.http.middlewares.traefik-https-redirect.redirectscheme.scheme=https"
      - "traefik.http.routers.traefik-http.middlewares=traefik-https-redirect"
      - "traefik.http.routers.traefik-secure.entrypoints=https"
      - "traefik.http.routers.traefik-secure.rule=Host(`traefik.local`)"
      - "traefik.http.routers.traefik-secure.middlewares=traefik-auth"
      - "traefik.http.routers.traefik-secure.tls=true"
      - "traefik.http.routers.traefik-secure.service=api@internal"

networks:
  proxy:
    external: true
5. Service Configuration Examples
Each service has its own docker-compose.yml file in the docker/ directory. Here's an example for FocalBoard:
yamlCopyversion: "3.8"

services:
  focalboard:
    image: mattermost/focalboard:latest
    container_name: focalboard
    restart: unless-stopped
    volumes:
      - ./data:/data
    environment:
      - WEBSERVER_ROOT=/
      - DISABLE_SSL_REDIRECT=true
    networks:
      - proxy
    labels:
      - "traefik.enable=true"
      - "traefik.http.routers.focalboard-http.rule=Host(`board.local`)"
      - "traefik.http.routers.focalboard-http.entrypoints=http"
      - "traefik.http.routers.focalboard-secure.rule=Host(`board.local`)"
      - "traefik.http.routers.focalboard-secure.entrypoints=https"
      - "traefik.http.routers.focalboard-secure.tls=true"
      - "traefik.http.services.focalboard-service.loadbalancer.server.port=8000"
      - "traefik.http.routers.focalboard-http.service=focalboard-service"
      - "traefik.http.routers.focalboard-secure.service=focalboard-service"
      - "traefik.http.middlewares.focalboard-headers.headers.customRequestHeaders.X-Forwarded-Proto=https"
      - "traefik.http.middlewares.focalboard-headers.headers.customRequestHeaders.X-Forwarded-Host=board.local"
      - "traefik.http.routers.focalboard-secure.middlewares=focalboard-headers"

networks:
  proxy:
    external: true
Using DNS with Docker Containers
Setting up Dnsmasq for local development
If you want to run a simple DNS server for your local network:
yamlCopyversion: '3'

services:
  dnsmasq:
    image: andyshinn/dnsmasq:latest
    container_name: dnsmasq
    restart: unless-stopped
    ports:
      - "53:53/udp"
    volumes:
      - ./conf.d:/etc/dnsmasq.d
    cap_add:
      - NET_ADMIN
Create DNS configuration in conf.d/local-dns.conf:
Copyserver=8.8.8.8
server=8.8.4.4
domain-needed
bogus-priv

# Custom DNS entries for HACKERMEN services
address=/traefik.local/192.168.1.x
address=/board.local/192.168.1.x
address=/git.local/192.168.1.x
# Add more entries as needed
Accessing Services
After deployment, access your services at:

Traefik Dashboard: https://traefik.local
FocalBoard: https://board.local
Gitea: https://git.local
VS Code: https://code.local
And others as configured

Security Considerations
Even on a local network, this deployment uses SSL for all services to prevent:

Local network sniffing
Man-in-the-middle attacks
Password interception

For production use, consider:

Proper certificate authority instead of self-signed certificates
Regular backups of configuration and data
Network isolation for sensitive services

Troubleshooting
Certificate Warnings
Since you're using self-signed certificates, your browser will show warnings. You can:

Click "Advanced" and "Proceed" for each service (temporary)
Import the self-signed certificate into your browser/OS (permanent)

DNS Issues
If domain names don't resolve:
bashCopy# Test DNS resolution
dig board.local @your-dns-server-ip
nslookup board.local your-dns-server-ip
Service Access Issues
If services aren't accessible:
bashCopy# Check containers
docker ps

# Check Traefik logs
docker logs traefik

# Verify Docker network
docker network inspect proxy
Maintenance
Updating Services
bashCopy# Pull new images and restart
docker-compose pull
docker-compose up -d
Backing Up Data
Each service stores data in volumes. Back up the following directories:

./data/ (Traefik configuration)
./docker/*/data/ (Service-specific data)