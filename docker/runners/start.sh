#!/bin/bash
set -e

# Required ENV variables
if [ -z "$REPO_URL" ] || [ -z "$RUNNER_TOKEN" ]; then
  echo "❌ Missing REPO_URL or RUNNER_TOKEN"
  exit 1
fi

echo "⚙️ Configuring runner..."

./config.sh \
  --url $REPO_URL \
  --token $RUNNER_TOKEN \
  --name "docker-runner-$(hostname)" \
  --labels "self-hosted,linux,docker" \
  --unattended \
  --work _work

echo "🚀 Starting runner..."
./run.sh