# 🚀 CI Pipeline: GitHub Actions → Jenkins → JFrog

This project demonstrates a CI pipeline where GitHub Actions triggers Jenkins using a self-hosted runner, and Jenkins builds a Docker image and pushes it to JFrog Artifactory.

---

## 🔁 Pipeline Flow


Developer Push → GitHub Actions → Self-Hosted Runner → Jenkins → Docker Build → JFrog


---

## 🧠 How It Works

1. Developer pushes code to GitHub  
2. GitHub Actions workflow triggers  
3. Job runs on self-hosted runner  
4. Runner calls Jenkins pipeline via API  
5. Jenkins:
   - Checks out code  
   - Builds Docker image  
   - Pushes image to JFrog Artifactory  

---

## 📁 Project Structure


ci-pipeline-github-jenkins-jfrog/
│
├── .github/workflows/ci.yml
├── docker/Dockerfile
├── jenkins/Jenkinsfile
├── scripts/
│ ├── runner-setup.sh
│ ├── jenkins-setup.sh
│ ├── jfrog-setup.sh
│ └── complete-setup.sh
├── app/
│ ├── app.js
│ ├── package.json
│ └── app.test.js
└── README.md


---

## ⚙️ Setup Guide

### 1. Setup GitHub Runner
```bash
chmod +x scripts/runner-setup.sh
./scripts/runner-setup.sh
2. Setup Jenkins
chmod +x scripts/jenkins-setup.sh
sudo ./scripts/jenkins-setup.sh

👉 Open Jenkins:

http://<your-ip>:8080
3. Setup JFrog
chmod +x scripts/jfrog-setup.sh
./scripts/jfrog-setup.sh
4. Configure GitHub Secrets

Add these in your repo:

JENKINS_URL
JENKINS_USER
JENKINS_TOKEN
JENKINS_JOB_NAME
🐳 Docker Build (Manual Test)
docker build -t test-app ./docker
🔗 Jenkins Pipeline

Jenkins pipeline performs:

Code checkout
Docker image build
Push to JFrog

JFrog Output

Docker images are pushed to:

<jfrog-url>/<image-name>:<tag>