# Use a stable Debian base image
FROM debian:stable-slim

# Install essential tools
RUN apt-get update && \
    apt-get install -y \
      curl \
      unzip \
      gnupg \
      software-properties-common \
      jq && \
    # Clean up
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Add the HashiCorp GPG key and APT repository
RUN curl -fsSL https://apt.releases.hashicorp.com/gpg | gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg && \
    echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | tee /etc/apt/sources.list.d/hashicorp.list && \
    apt-get update && \
    # Installs latest versions of Vault, Consul, and Nomad
    apt-get install -y \
      vault \
      consul \
      nomad && \
    # Clean up 
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Create a non-root user
RUN useradd -m goldenuser
USER goldenuser
WORKDIR /home/goldenuser

# Verify the installed versions when the container starts
CMD ["sh", "-c", "echo 'Tools installed:'; vault --version; consul --version; nomad --version; jq --version"]