#!/bin/bash

# Dokku Installation Script
# This script installs Dokku on the host system

set -e

echo "Installing Dokku..."

# Install Docker if not already installed
if ! command -v docker &> /dev/null; then
    echo "Installing Docker..."
    curl -fsSL https://get.docker.com | sh
    sudo usermod -aG docker $USER
fi

# Install Dokku
wget -NP . https://dokku.com/install/v0.34.9/bootstrap.sh
sudo DOKKU_TAG=v0.34.9 bash bootstrap.sh

# Configure Dokku domain
sudo dokku domains:set-global brainiac.gg

# Install useful Dokku plugins
echo "Installing Dokku plugins..."

# Postgres plugin
sudo dokku plugin:install https://github.com/dokku/dokku-postgres.git postgres

# MySQL plugin
sudo dokku plugin:install https://github.com/dokku/dokku-mysql.git mysql

# Redis plugin
sudo dokku plugin:install https://github.com/dokku/dokku-redis.git redis

# Let's Encrypt plugin (optional if using Traefik)
# sudo dokku plugin:install https://github.com/dokku/dokku-letsencrypt.git

# HTTP Auth plugin
sudo dokku plugin:install https://github.com/dokku/dokku-http-auth.git

echo "Dokku installation complete!"
echo ""
echo "Next steps:"
echo "1. Add your SSH key to Dokku: cat ~/.ssh/id_rsa.pub | sudo dokku ssh-keys:add admin"
echo "2. Create your first app: dokku apps:create myapp"
echo "3. Configure git remote: git remote add dokku dokku@dokku.brainiac.gg:myapp"
echo "4. Deploy: git push dokku main"