FROM ubuntu:22.04

# Install essential development tools
RUN apt-get update && apt-get install -y \
    git \
    curl \
    wget \
    vim \
    nano \
    mariadb-client \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /workspace

# Configure git (will be overridden by user settings)
RUN git config --global init.defaultBranch main