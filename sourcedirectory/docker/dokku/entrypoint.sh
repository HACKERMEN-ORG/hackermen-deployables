#!/bin/bash
set -e

# Function to wait for Docker daemon
wait_for_docker() {
    echo "Waiting for Docker daemon to be available..."
    while ! docker version > /dev/null 2>&1; do
        sleep 1
    done
    echo "Docker daemon is available"
}

# Configure global domain if set
if [ -n "$DOKKU_DOMAIN" ]; then
    echo "Setting global domain to $DOKKU_DOMAIN"
    dokku domains:set-global "$DOKKU_DOMAIN"
fi

# Setup SSH keys if provided
if [ -d "/ssh-keys" ]; then
    echo "Setting up SSH keys..."
    for key in /ssh-keys/*.pub; do
        if [ -f "$key" ]; then
            keyname=$(basename "$key" .pub)
            cat "$key" | dokku ssh-keys:add "$keyname" || true
        fi
    done
fi

# Initialize nginx if needed
if [ ! -f /etc/nginx/sites-enabled/00_dokku.conf ]; then
    dokku nginx:initialize
fi

# Wait for Docker daemon to be available
wait_for_docker

# Generate SSH host keys if they don't exist
if [ ! -f /etc/ssh/ssh_host_rsa_key ]; then
    ssh-keygen -A
fi

# Start nginx in background
nginx

# Execute the main command
exec "$@"