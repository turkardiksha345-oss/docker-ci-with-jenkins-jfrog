#!/bin/bash

set -e

echo "🚀 Setting up GitHub Actions Runner..."

# ===== CONFIG =====
RUNNER_DIR="$HOME/actions-runner"
REPO_URL="https://github.com/turkardiksha345-oss/docker-ci-with-jenkins-jfrog"

# ===== INSTALL DEPENDENCIES =====
echo "📦 Installing dependencies..."
sudo apt update
sudo apt install -y curl tar jq git

# ===== CLEAN OLD RUNNER (optional) =====
if [ -d "$RUNNER_DIR" ]; then
  echo "⚠️ Existing runner found, removing..."
  rm -rf $RUNNER_DIR
fi

# ===== CREATE RUNNER DIR =====
mkdir -p $RUNNER_DIR
cd $RUNNER_DIR

# ===== DOWNLOAD RUNNER =====
echo "⬇️ Downloading runner..."
curl -o actions-runner.tar.gz -L https://github.com/actions/runner/releases/latest/download/actions-runner-linux-x64.tar.gz
tar xzf actions-runner.tar.gz
rm actions-runner.tar.gz

# ===== INSTALL DEPENDENCIES (runner specific) =====
echo "🔧 Installing runner dependencies..."
sudo ./bin/installdependencies.sh

# ===== GET TOKEN =====
echo ""
echo "👉 Go to GitHub:"
echo "Settings → Actions → Runners → New self-hosted runner"
echo "Copy ONLY the token"
echo ""

read -p "🔑 Enter Runner Token: " TOKEN

# ===== CONFIGURE RUNNER =====
echo "⚙️ Configuring runner..."
./config.sh \
  --url $REPO_URL \
  --token $TOKEN \
  --name "ec2-runner-$(hostname)" \
  --labels "self-hosted,linux,ec2" \
  --unattended \
  --work _work

# ===== INSTALL AS SERVICE =====
echo "🔧 Installing as service..."
sudo ./svc.sh install
sudo ./svc.sh start

echo ""
echo "✅ Runner setup completed!"
echo "👉 Check GitHub → Settings → Actions → Runners → ONLINE"