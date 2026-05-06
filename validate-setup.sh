#!/bin/bash

set -e

echo "🔍 Validating CI Pipeline Setup..."
echo "================================="

# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'

check() {
    if [ $1 -eq 0 ]; then
        echo -e "${GREEN}✅ $2${NC}"
    else
        echo -e "${RED}❌ $2${NC}"
    fi
}

warn() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

# -------------------------
# 📁 Check Project Structure
# -------------------------
echo ""
echo "📁 Checking Project Structure..."

[ -f ".github/workflows/ci.yml" ]
check $? "GitHub Actions workflow exists"

[ -f "jenkins/Jenkinsfile" ]
check $? "Jenkinsfile exists"

[ -f "docker/Dockerfile" ]
check $? "Dockerfile exists"

[ -d "scripts" ]
check $? "Scripts directory exists"

[ -f "app/app.js" ]
check $? "Node app exists"

[ -f "app/package.json" ]
check $? "package.json exists"

# -------------------------
# ⚙️ Validate Workflow
# -------------------------
echo ""
echo "⚙️ Validating GitHub Actions..."

grep -q "runs-on: self-hosted" .github/workflows/ci.yml
check $? "Self-hosted runner configured"

grep -q "JENKINS_URL" .github/workflows/ci.yml
check $? "Jenkins URL configured"

# -------------------------
# 🐳 Validate Docker
# -------------------------
echo ""
echo "🐳 Checking Docker..."

if command -v docker &> /dev/null; then
    echo -e "${GREEN}✅ Docker installed${NC}"
else
    echo -e "${RED}❌ Docker not installed${NC}"
fi

# -------------------------
# 🐔 Check Jenkins
# -------------------------
echo ""
echo "🐔 Checking Jenkins..."

if systemctl is-active --quiet jenkins; then
    echo -e "${GREEN}✅ Jenkins is running${NC}"
else
    warn "Jenkins is not running"
fi

# -------------------------
# 🤖 Check Runner
# -------------------------
echo ""
echo "🤖 Checking GitHub Runner..."

if systemctl list-units --type=service | grep -q github-runner; then
    echo -e "${GREEN}✅ Runner service found${NC}"
else
    warn "Runner service not found (manual run is also fine)"
fi

# -------------------------
# 🎯 Summary
# -------------------------
echo ""
echo "🎯 Validation Complete!"
echo ""
echo "Flow:"
echo "GitHub → Runner → Jenkins → Docker → JFrog"
echo ""
echo "Next Step:"
echo "👉 Push code to GitHub to trigger pipeline"