#!/bin/bash

set -e

echo "🚀 Setting up GitHub Actions Runner..."

# Install dependencies
sudo apt update
sudo apt install -y curl tar jq

# Create runner directory
mkdir -p ~/actions-runner
cd ~/actions-runner

# Download latest runner
echo "⬇️ Downloading runner..."
curl -o actions-runner.tar.gz -L https://github.com/actions/runner/releases/latest/download/actions-runner-linux-x64.tar.gz
tar xzf actions-runner.tar.gz

# Configure runner (MANUAL TOKEN)
echo ""
echo "👉 Go to your GitHub repo:"
echo "Settings → Actions → Runners → New self-hosted runner"
echo "Copy the config command and paste it here"
echo ""

read -p "Paste your config command here: " CONFIG_CMD
eval $CONFIG_CMD

# Start runner
echo "▶️ Starting runner..."
./run.sh