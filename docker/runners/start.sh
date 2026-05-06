#!/bin/bash
set -e

echo "🚀 Starting GitHub Runner..."

# =========================
# VALIDATE ENV VARIABLES
# =========================
if [ -z "$REPO_URL" ] || [ -z "$GITHUB_PAT" ]; then
  echo "❌ Missing REPO_URL or GITHUB_PAT"
  exit 1
fi

# =========================
# CHECK REQUIRED TOOLS
# =========================
if ! command -v curl >/dev/null 2>&1; then
  echo "❌ curl not installed"
  exit 1
fi

if ! command -v jq >/dev/null 2>&1; then
  echo "❌ jq not installed"
  exit 1
fi

# =========================
# EXTRACT REPO PATH
# =========================
REPO_PATH=$(echo "$REPO_URL" | sed -E 's#https://github.com/##')

echo "📦 Repo: $REPO_PATH"

# =========================
# GENERATE RUNNER TOKEN
# =========================
echo "🔐 Generating fresh runner token..."

RUNNER_TOKEN=$(curl -s -X POST \
  -H "Authorization: token $GITHUB_PAT" \
  -H "Accept: application/vnd.github+json" \
  https://api.github.com/repos/$REPO_PATH/actions/runners/registration-token \
  | jq -r .token)

if [ -z "$RUNNER_TOKEN" ] || [ "$RUNNER_TOKEN" = "null" ]; then
  echo "❌ Failed to fetch runner token"
  exit 1
fi

echo "✅ Token generated"

# =========================
# CLEAN OLD RUNNER (important for restart)
# =========================
if [ -f ".runner" ]; then
  echo "♻️ Removing existing runner config..."
  ./config.sh remove --unattended --token "$RUNNER_TOKEN" || true
fi

# =========================
# CONFIGURE RUNNER
# =========================
echo "⚙️ Configuring runner..."

./config.sh \
  --url "$REPO_URL" \
  --token "$RUNNER_TOKEN" \
  --name "k8s-runner-$(hostname)" \
  --labels "self-hosted,k8s,docker" \
  --unattended \
  --replace \
  --work _work

# =========================
# START RUNNER
# =========================
echo "🚀 Runner is starting..."
exec ./run.sh