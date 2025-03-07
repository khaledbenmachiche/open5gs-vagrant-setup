#!/bin/bash
set -e  # Exit immediately if a command exits with a non-zero status
set -o pipefail  # Catch errors in piped commands
set -u  # Treat unset variables as an error

# Ensure script runs with root privileges
if [[ $EUID -ne 0 ]]; then
    echo "This script must be run as root. Use sudo."
    exit 1
fi

# Update and install prerequisites
apt-get update -y && apt-get install -y gnupg ca-certificates curl
apt-get install software-properties-common
# Add MongoDB repository key
curl -fsSL https://pgp.mongodb.com/server-6.0.asc | gpg --dearmor -o /usr/share/keyrings/mongodb-server-6.0.gpg

# Add MongoDB repository
echo "deb [arch=amd64,arm64 signed-by=/usr/share/keyrings/mongodb-server-6.0.gpg] https://repo.mongodb.org/apt/ubuntu focal/mongodb-org/6.0 multiverse" | tee /etc/apt/sources.list.d/mongodb-org-6.0.list

# Update and install MongoDB
apt-get update -y
apt-get install -y mongodb-org || { echo "Failed to install MongoDB"; exit 1; }

# Enable and start MongoDB service
systemctl enable --now mongod

# Add Open5GS repository
add-apt-repository -y ppa:open5gs/latest
apt-get update -y --fix-missing
sudo apt-get install -f
apt-get install -y open5gs

# Install Node.js
mkdir -p /etc/apt/keyrings
curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg
export NODE_MAJOR=20
echo "deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_$NODE_MAJOR.x nodistro main" | tee /etc/apt/sources.list.d/nodesource.list

apt-get update -y
apt-get install -y nodejs || { echo "Failed to install Node.js"; exit 1; }

# Install Open5GS WebUI
curl -fsSL https://open5gs.org/open5gs/assets/webui/install | bash || { echo "Failed to install Open5GS WebUI"; exit 1; }

echo "Installation completed successfully!"