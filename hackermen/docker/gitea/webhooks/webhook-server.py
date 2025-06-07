#!/usr/bin/env python3

"""
Webhook server for Gitea to Dokku CI/CD
Receives webhooks from Gitea and triggers Dokku deployments
"""

import json
import subprocess
import hmac
import hashlib
from flask import Flask, request, jsonify
import os

app = Flask(__name__)

# Configuration
WEBHOOK_SECRET = os.environ.get('WEBHOOK_SECRET', 'your-webhook-secret')
DOKKU_HOST = os.environ.get('DOKKU_HOST', 'dokku.brainiac.gg')
DEPLOY_SCRIPT = '/webhooks/dokku-deploy.sh'

def verify_webhook_signature(payload_body, signature):
    """Verify that the webhook came from Gitea"""
    if not signature:
        return False
    
    expected_signature = hmac.new(
        WEBHOOK_SECRET.encode('utf-8'),
        payload_body,
        hashlib.sha256
    ).hexdigest()
    
    return hmac.compare_digest(signature, expected_signature)

@app.route('/webhook', methods=['POST'])
def handle_webhook():
    """Handle incoming webhooks from Gitea"""
    
    # Verify webhook signature
    signature = request.headers.get('X-Gitea-Signature')
    if not verify_webhook_signature(request.data, signature):
        return jsonify({'error': 'Invalid signature'}), 401
    
    # Parse webhook payload
    try:
        payload = json.loads(request.data)
    except json.JSONDecodeError:
        return jsonify({'error': 'Invalid JSON'}), 400
    
    # Check if this is a push event
    if request.headers.get('X-Gitea-Event') != 'push':
        return jsonify({'message': 'Not a push event, ignoring'}), 200
    
    # Extract repository information
    repo_name = payload.get('repository', {}).get('name')
    repo_url = payload.get('repository', {}).get('clone_url')
    branch = payload.get('ref', '').replace('refs/heads/', '')
    
    if not all([repo_name, repo_url, branch]):
        return jsonify({'error': 'Missing required fields'}), 400
    
    # Only deploy from main/master branch
    if branch not in ['main', 'master']:
        return jsonify({'message': f'Skipping deployment for branch {branch}'}), 200
    
    # Trigger deployment
    try:
        result = subprocess.run(
            [DEPLOY_SCRIPT, repo_url, repo_name, branch],
            capture_output=True,
            text=True,
            check=True
        )
        return jsonify({
            'message': 'Deployment triggered successfully',
            'output': result.stdout
        }), 200
    except subprocess.CalledProcessError as e:
        return jsonify({
            'error': 'Deployment failed',
            'output': e.stderr
        }), 500

@app.route('/health', methods=['GET'])
def health_check():
    """Health check endpoint"""
    return jsonify({'status': 'healthy'}), 200

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=9000)