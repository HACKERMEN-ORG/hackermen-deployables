#!/bin/bash

# Gitea to Dokku deployment webhook handler
# This script handles webhooks from Gitea and triggers Dokku deployments

set -e

# Configuration
DOKKU_HOST="dokku.brainiac.gg"
DOKKU_USER="dokku"
TEMP_DIR="/tmp/dokku-deploy"

# Function to deploy to Dokku
deploy_to_dokku() {
    local repo_url=$1
    local app_name=$2
    local branch=${3:-main}
    
    echo "Deploying $app_name from $repo_url..."
    
    # Create temporary directory
    mkdir -p "$TEMP_DIR"
    cd "$TEMP_DIR"
    
    # Clone the repository
    if [ -d "$app_name" ]; then
        rm -rf "$app_name"
    fi
    git clone "$repo_url" "$app_name"
    cd "$app_name"
    
    # Add Dokku remote and push
    git remote add dokku "dokku@$DOKKU_HOST:$app_name"
    git push dokku "$branch:main" --force
    
    # Cleanup
    cd /
    rm -rf "$TEMP_DIR/$app_name"
    
    echo "Deployment complete for $app_name"
}

# Parse webhook payload (this is a simple example)
# In production, you'd parse the JSON payload from Gitea
if [ $# -lt 2 ]; then
    echo "Usage: $0 <repo_url> <app_name> [branch]"
    exit 1
fi

deploy_to_dokku "$1" "$2" "${3:-main}"