#!/bin/bash

# Create directory for certs if it doesn't exist
mkdir -p ./data/certs

# Generate a private key
openssl genrsa -out ./data/certs/local.key 2048

# Create a certificate signing request
openssl req -new -key ./data/certs/local.key -out ./data/certs/local.csr -subj "/CN=*.local/O=SOURCEDIRECTORY/C=US"

# Create self-signed certificate valid for 365 days
openssl x509 -req -days 365 -in ./data/certs/local.csr -signkey ./data/certs/local.key -out ./data/certs/local.crt

# Create DH parameters for additional security
openssl dhparam -out ./data/certs/dhparam.pem 2048

# Set permissions
chmod 600 ./data/certs/local.key
chmod 644 ./data/certs/local.crt
chmod 644 ./data/certs/dhparam.pem

# Create empty acme.json file with proper permissions
touch ./data/acme.json
chmod 600 ./data/acme.json

echo "Self-signed certificates have been generated in ./data/certs/"