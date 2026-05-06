#!/bin/bash

set -e

echo "🚀 JFrog Setup"

read -p "Enter JFrog URL (example: mydomain.jfrog.io): " JFROG_URL
read -p "Enter JFrog Username: " USERNAME
read -s -p "Enter JFrog Password/API Key: " PASSWORD
echo ""

echo "🔐 Logging into JFrog Docker registry..."

echo $PASSWORD | docker login $JFROG_URL -u $USERNAME --password-stdin

echo "✅ Login successful!"

echo ""
echo "👉 Now add these in Jenkins credentials:"
echo "JFROG_USER = $USERNAME"
echo "JFROG_PASSWORD = <your-password>"
echo "DOCKER_REGISTRY = $JFROG_URL"