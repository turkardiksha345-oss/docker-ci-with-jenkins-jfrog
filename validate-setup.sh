#!/bin/bash

# Quick Validation Script for CI/CD Pipeline
# This script validates that all components are properly configured

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

log_info() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

log_warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

log_step() {
    echo -e "${BLUE}[STEP]${NC} $1"
}

echo "🔍 CI/CD Pipeline Validation"
echo "============================"

# Check directory structure
log_step "Checking project structure..."
if [ -d ".github/workflows" ] && [ -f ".github/workflows/ci.yml" ]; then
    log_info "✅ GitHub Actions workflow found"
else
    log_error "❌ GitHub Actions workflow missing"
fi

if [ -f "jenkins/Jenkinsfile" ]; then
    log_info "✅ Jenkins pipeline found"
else
    log_error "❌ Jenkins pipeline missing"
fi

if [ -f "docker/Dockerfile" ]; then
    log_info "✅ Docker configuration found"
else
    log_error "❌ Docker configuration missing"
fi

if [ -d "scripts" ]; then
    log_info "✅ Setup scripts found"
else
    log_error "❌ Setup scripts missing"
fi

# Check application files
log_step "Checking application files..."
if [ -f "app/app.js" ] || [ -f "app/app.py" ]; then
    log_info "✅ Application code found"
else
    log_error "❌ Application code missing"
fi

if [ -f "app/package.json" ] || [ -f "app/requirements.txt" ]; then
    log_info "✅ Dependencies configuration found"
else
    log_error "❌ Dependencies configuration missing"
fi

if [ -f "app/app.test.js" ] || [ -f "app/test_app.py" ]; then
    log_info "✅ Test files found"
else
    log_warn "⚠️  Test files not found (optional)"
fi

# Validate GitHub Actions workflow
log_step "Validating GitHub Actions workflow..."
if grep -q "runs-on: self-hosted" .github/workflows/ci.yml; then
    log_info "✅ Self-hosted runner configured"
else
    log_error "❌ Self-hosted runner not configured"
fi

if grep -q "secrets.JENKINS_" .github/workflows/ci.yml; then
    log_info "✅ Jenkins secrets referenced"
else
    log_warn "⚠️  Jenkins secrets not referenced"
fi

# Validate Jenkins pipeline
log_step "Validating Jenkins pipeline..."
if grep -q "DOCKER_REGISTRY" jenkins/Jenkinsfile && grep -q "JFROG_" jenkins/Jenkinsfile; then
    log_info "✅ Jenkins pipeline configured for JFrog"
else
    log_warn "⚠️  Jenkins JFrog configuration incomplete"
fi

# Check Docker configuration
log_step "Validating Docker configuration..."
if grep -q "HEALTHCHECK" docker/Dockerfile; then
    log_info "✅ Docker health check configured"
else
    log_warn "⚠️  Docker health check missing"
fi

# Summary
echo ""
echo "📊 Validation Summary"
echo "===================="
echo ""
echo "🎯 CI/CD Flow Components:"
echo "   1. GitHub Actions Runner → Self-hosted runner setup"
echo "   2. Jenkins Automation → Pipeline orchestration"
echo "   3. JFrog Deployment → Artifact storage"
echo ""
echo "📁 Key Files:"
echo "   • .github/workflows/ci.yml - GitHub Actions workflow"
echo "   • jenkins/Jenkinsfile - Jenkins pipeline"
echo "   • docker/Dockerfile - Container configuration"
echo "   • scripts/runner-setup.sh - Runner setup"
echo "   • app/ - Sample application"
echo ""
echo "🚀 Quick Setup Commands:"
echo "   1. Setup runner: ./scripts/runner-setup.sh"
echo "   2. Setup Jenkins: ./scripts/jenkins-setup.sh"
echo "   3. Setup JFrog: ./scripts/jfrog-setup.sh"
echo "   4. Test app: cd app && npm test (or python -m pytest)"
echo "   5. Test Docker: docker build -t test ./docker"
echo ""
echo "🔐 Required Secrets (GitHub):"
echo "   • JENKINS_URL"
echo "   • JENKINS_USER"
echo "   • JENKINS_TOKEN"
echo "   • JENKINS_TRIGGER_TOKEN"
echo ""
echo "🔧 Required Credentials (Jenkins):"
echo "   • JFROG_USER"
echo "   • JFROG_PASSWORD"
echo ""
echo "✅ Validation completed! Check above for any issues."