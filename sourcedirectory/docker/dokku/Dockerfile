FROM ubuntu:22.04

# Avoid prompts during package installation
ENV DEBIAN_FRONTEND=noninteractive
ENV DOKKU_TAG=v0.34.9

# Install dependencies
RUN apt-get update && apt-get install -y \
    curl \
    wget \
    git \
    make \
    software-properties-common \
    apt-transport-https \
    ca-certificates \
    gnupg \
    lsb-release \
    sudo \
    openssh-server \
    nginx \
    dnsutils \
    netcat-openbsd \
    python3 \
    python3-pip \
    && rm -rf /var/lib/apt/lists/*

# Install Docker CLI (for docker-in-docker support)
RUN curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add - && \
    add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" && \
    apt-get update && \
    apt-get install -y docker-ce-cli && \
    rm -rf /var/lib/apt/lists/*

# Install Dokku
RUN wget -NP /tmp https://dokku.com/install/${DOKKU_TAG}/bootstrap.sh && \
    DOKKU_TAG=${DOKKU_TAG} bash /tmp/bootstrap.sh && \
    rm /tmp/bootstrap.sh

# Install Dokku plugins
RUN dokku plugin:install https://github.com/dokku/dokku-postgres.git postgres --core && \
    dokku plugin:install https://github.com/dokku/dokku-mysql.git mysql --core && \
    dokku plugin:install https://github.com/dokku/dokku-redis.git redis --core && \
    dokku plugin:install https://github.com/dokku/dokku-http-auth.git --core

# Configure SSH
RUN mkdir /var/run/sshd && \
    echo 'root:dokku' | chpasswd && \
    sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config && \
    sed -i 's/#PasswordAuthentication yes/PasswordAuthentication no/' /etc/ssh/sshd_config && \
    echo "PubkeyAuthentication yes" >> /etc/ssh/sshd_config

# Create dokku user if it doesn't exist
RUN id -u dokku &>/dev/null || useradd -m -s /bin/bash dokku && \
    echo "dokku ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/dokku && \
    chmod 0440 /etc/sudoers.d/dokku

# Create necessary directories
RUN mkdir -p /home/dokku/.ssh && \
    chmod 700 /home/dokku/.ssh && \
    chown -R dokku:dokku /home/dokku/.ssh

# Expose ports
EXPOSE 22 80 443

# Create entrypoint script
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
CMD ["/usr/sbin/sshd", "-D"]