#!/bin/bash

set -e

echo "🚀 Setting up CI Pipeline Environment..."

# Install Docker
echo "🐳 Installing Docker..."
curl -fsSL https://get.docker.com | sh
sudo systemctl enable docker
sudo systemctl start docker

# Install basic tools
sudo apt update
sudo apt install -y git curl jq

# Setup Jenkins
echo "🐔 Installing Jenkins..."
bash ./scripts/jenkins-setup.sh

# Optional: Setup Runner
read -p "Setup GitHub runner? (y/n): " RUNNER
if [[ "$RUNNER" == "y" ]]; then
    bash ./scripts/runner-setup.sh
fi

# Optional: Setup JFrog
read -p "Setup JFrog login? (y/n): " JFROG
if [[ "$JFROG" == "y" ]]; then
    bash ./scripts/jfrog-setup.sh
fi

echo "✅ Setup Completed!"