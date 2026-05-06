#!/bin/bash

set -e

echo "🚀 Installing Jenkins..."

# -------------------------
# Update system
# -------------------------
sudo apt update

# -------------------------
# Install Java (required)
# -------------------------
sudo apt install -y openjdk-17-jdk

# -------------------------
# Remove old Jenkins repo (important fix)
# -------------------------
sudo rm -f /etc/apt/sources.list.d/jenkins.list
sudo rm -f /usr/share/keyrings/jenkins-keyring.asc

# -------------------------
# Add Jenkins GPG key (NEW METHOD)
# -------------------------
sudo mkdir -p /usr/share/keyrings

curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key \
| sudo tee /usr/share/keyrings/jenkins-keyring.asc > /dev/null

# -------------------------
# Add Jenkins repository
# -------------------------
echo "deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] https://pkg.jenkins.io/debian-stable binary/" \
| sudo tee /etc/apt/sources.list.d/jenkins.list > /dev/null

# -------------------------
# Update again
# -------------------------
sudo apt update

# -------------------------
# Install Jenkins
# -------------------------
sudo apt install -y jenkins

# -------------------------
# Start Jenkins
# -------------------------
sudo systemctl enable jenkins
sudo systemctl start jenkins

# -------------------------
# Add Jenkins to Docker group
# -------------------------
sudo usermod -aG docker jenkins

# -------------------------
# Verify
# -------------------------
echo ""
echo "✅ Jenkins Installed Successfully!"
echo ""

echo "🌐 Access Jenkins at:"
echo "http://$(hostname -I | awk '{print $1}'):8080"

echo ""
echo "🔐 Initial Admin Password:"
sudo cat /var/lib/jenkins/secrets/initialAdminPassword
echo ""