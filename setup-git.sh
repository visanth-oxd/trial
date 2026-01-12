#!/bin/bash

# Git Repository Setup Script
# This script helps you initialize and push to a Git repository

set -e

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}Git Repository Setup${NC}"
echo -e "${BLUE}========================================${NC}"
echo ""

# Check if git is installed
if ! command -v git &> /dev/null; then
    echo -e "${RED}Error: Git is not installed${NC}"
    echo "Please install Git first: https://git-scm.com/downloads"
    exit 1
fi

# Check if already a git repo
if [ -d ".git" ]; then
    echo -e "${YELLOW}⚠ Git repository already initialized${NC}"
    read -p "Do you want to continue? (y/n) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        exit 1
    fi
else
    echo -e "${GREEN}Initializing Git repository...${NC}"
    git init
    echo -e "${GREEN}✓ Git repository initialized${NC}"
fi

echo ""
echo -e "${BLUE}Step 1: Adding files to Git${NC}"
git add .
echo -e "${GREEN}✓ Files added${NC}"

echo ""
echo -e "${BLUE}Step 2: Creating initial commit${NC}"
git commit -m "Initial commit: Modular Terraform infrastructure with CI/CD pipeline

- Created modular structure (vpc, ec2-instance, security-group)
- Added dev and prod environment configurations
- Implemented GitHub Actions CI/CD pipeline
- Added security improvements and best practices
- Included comprehensive documentation"
echo -e "${GREEN}✓ Initial commit created${NC}"

echo ""
echo -e "${BLUE}Step 3: Setting up remote repository${NC}"
echo ""
echo "Choose your Git hosting platform:"
echo "1) GitHub"
echo "2) GitLab"
echo "3) Other (manual setup)"
echo "4) Skip (set up remote later)"
echo ""
read -p "Enter choice (1-4): " choice

case $choice in
    1)
        echo ""
        read -p "Enter your GitHub username: " username
        read -p "Enter repository name: " repo_name
        read -p "Use SSH? (y/n): " use_ssh
        
        if [[ $use_ssh =~ ^[Yy]$ ]]; then
            remote_url="git@github.com:${username}/${repo_name}.git"
        else
            remote_url="https://github.com/${username}/${repo_name}.git"
        fi
        
        echo ""
        echo -e "${YELLOW}⚠ Make sure you've created the repository on GitHub first!${NC}"
        echo -e "${YELLOW}   Go to: https://github.com/new${NC}"
        echo ""
        read -p "Press Enter after creating the repository..."
        
        git remote add origin "$remote_url" 2>/dev/null || git remote set-url origin "$remote_url"
        echo -e "${GREEN}✓ Remote added: ${remote_url}${NC}"
        ;;
    2)
        echo ""
        read -p "Enter your GitLab username: " username
        read -p "Enter repository name: " repo_name
        
        remote_url="https://gitlab.com/${username}/${repo_name}.git"
        
        echo ""
        echo -e "${YELLOW}⚠ Make sure you've created the project on GitLab first!${NC}"
        echo -e "${YELLOW}   Go to: https://gitlab.com/projects/new${NC}"
        echo ""
        read -p "Press Enter after creating the project..."
        
        git remote add origin "$remote_url" 2>/dev/null || git remote set-url origin "$remote_url"
        echo -e "${GREEN}✓ Remote added: ${remote_url}${NC}"
        ;;
    3)
        echo ""
        read -p "Enter remote repository URL: " remote_url
        git remote add origin "$remote_url" 2>/dev/null || git remote set-url origin "$remote_url"
        echo -e "${GREEN}✓ Remote added: ${remote_url}${NC}"
        ;;
    4)
        echo -e "${YELLOW}⚠ Skipping remote setup${NC}"
        echo "You can add a remote later with:"
        echo "  git remote add origin <repository-url>"
        exit 0
        ;;
    *)
        echo -e "${RED}Invalid choice${NC}"
        exit 1
        ;;
esac

echo ""
echo -e "${BLUE}Step 4: Renaming branch to main${NC}"
git branch -M main 2>/dev/null || echo -e "${YELLOW}Branch already named main${NC}"
echo -e "${GREEN}✓ Branch set to main${NC}"

echo ""
echo -e "${BLUE}Step 5: Pushing to remote${NC}"
echo -e "${YELLOW}Pushing to remote repository...${NC}"

if git push -u origin main; then
    echo ""
    echo -e "${GREEN}========================================${NC}"
    echo -e "${GREEN}✓ Successfully pushed to remote!${NC}"
    echo -e "${GREEN}========================================${NC}"
    echo ""
    echo "Next steps:"
    echo "1. Check your repository on GitHub/GitLab"
    echo "2. Go to the 'Actions' tab to see the CI/CD pipeline"
    echo "3. The pipeline should run automatically and show ✅ when successful"
    echo ""
else
    echo ""
    echo -e "${RED}✗ Push failed${NC}"
    echo ""
    echo "Common issues:"
    echo "1. Repository doesn't exist yet - create it first"
    echo "2. Authentication failed - check your credentials"
    echo "3. Remote has files - try: git pull origin main --allow-unrelated-histories"
    echo ""
    echo "You can push manually later with:"
    echo "  git push -u origin main"
    exit 1
fi

