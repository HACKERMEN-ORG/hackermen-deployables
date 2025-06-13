FROM python:3.11-slim

WORKDIR /app

# Install dependencies
RUN pip install flask gunicorn

# Install git and ssh client for deployments
RUN apt-get update && \
    apt-get install -y git openssh-client && \
    rm -rf /var/lib/apt/lists/*

# Copy webhook server and scripts
COPY webhook-server.py /app/
COPY dokku-deploy.sh /webhooks/
RUN chmod +x /webhooks/dokku-deploy.sh

# Create SSH directory
RUN mkdir -p /root/.ssh && \
    chmod 700 /root/.ssh

EXPOSE 9000

CMD ["gunicorn", "--bind", "0.0.0.0:9000", "webhook-server:app"]