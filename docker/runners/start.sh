#!/bin/bash
set -e

# Validate required ENV
if [ -z "$REPO_URL" ] || [ -z "$GITHUB_PAT" ]; then
  echo "❌ Missing REPO_URL or GITHUB_PAT"
  exit 1
fi

echo "🔐 Generating fresh runner token..."

# Extract owner/repo from URL
REPO_PATH=$(echo $REPO_URL | sed -E 's#https://github.com/##')

# Generate token from GitHub API
RUNNER_TOKEN=$(curl -s -X POST \
  -H "Authorization: token $GITHUB_PAT" \
  https://api.github.com/repos/$REPO_PATH/actions/runners/registration-token \
  | jq -r .token)

if [ -z "$RUNNER_TOKEN" ] || [ "$RUNNER_TOKEN" = "null" ]; then
  echo "❌ Failed to fetch runner token"
  exit 1
fi

echo "⚙️ Configuring runner..."

./config.sh \
  --url $REPO_URL \
  --token $RUNNER_TOKEN \
  --name "k8s-runner-$(hostname)" \
  --labels "self-hosted,k8s,docker" \
  --unattended \
  --replace \
  --work _work

echo "🚀 Starting runner..."
./run.sh