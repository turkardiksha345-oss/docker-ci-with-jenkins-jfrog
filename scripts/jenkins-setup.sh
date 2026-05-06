#!/bin/bash

set -e

echo "🚀 Installing Jenkins..."

# Update system
sudo apt update

# Install Java (required)
sudo apt install -y openjdk-17-jdk

# Add Jenkins repo
curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io.key | sudo tee \
  /usr/share/keyrings/jenkins-keyring.asc > /dev/null

echo "deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] \
  https://pkg.jenkins.io/debian-stable binary/" | sudo tee \
  /etc/apt/sources.list.d/jenkins.list > /dev/null

sudo apt update

# Install Jenkins
sudo apt install -y jenkins

# Start Jenkins
sudo systemctl enable jenkins
sudo systemctl start jenkins

# Add Jenkins to docker group
sudo usermod -aG docker jenkins

echo "✅ Jenkins Installed!"
echo "👉 Access: http://<your-ip>:8080"
echo "👉 Password:"
sudo cat /var/lib/jenkins/secrets/initialAdminPassword