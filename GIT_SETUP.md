# Git Repository Setup Guide

This guide will help you initialize this project as a Git repository and push it to a remote (GitHub, GitLab, etc.).

## Step 1: Initialize Git Repository

```bash
cd /Users/visanth/Downloads/devops-engineer-task
git init
```

## Step 2: Add All Files

```bash
# Add all files to staging
git add .

# Check what will be committed
git status
```

## Step 3: Create Initial Commit

```bash
git commit -m "Initial commit: Modular Terraform infrastructure with CI/CD pipeline

- Created modular structure (vpc, ec2-instance, security-group)
- Added dev and prod environment configurations
- Implemented GitHub Actions CI/CD pipeline
- Added security improvements and best practices
- Included comprehensive documentation"
```

## Step 4: Create Remote Repository

### Option A: GitHub (Recommended)

1. **Create a new repository on GitHub:**
   - Go to https://github.com/new
   - Repository name: `terraform-infrastructure` (or your preferred name)
   - Description: "Modular Terraform infrastructure for AWS with CI/CD"
   - Choose **Public** or **Private**
   - **DO NOT** initialize with README, .gitignore, or license (we already have these)
   - Click "Create repository"

2. **Connect local repo to GitHub:**
   ```bash
   # Replace YOUR_USERNAME and REPO_NAME with your actual values
   git remote add origin https://github.com/YOUR_USERNAME/REPO_NAME.git
   
   # Or if using SSH:
   git remote add origin git@github.com:YOUR_USERNAME/REPO_NAME.git
   ```

3. **Push to GitHub:**
   ```bash
   # Rename default branch to main (if needed)
   git branch -M main
   
   # Push to remote
   git push -u origin main
   ```

### Option B: GitLab

1. **Create a new project on GitLab:**
   - Go to https://gitlab.com/projects/new
   - Project name: `terraform-infrastructure`
   - Visibility: Public or Private
   - **DO NOT** initialize with README
   - Click "Create project"

2. **Connect local repo to GitLab:**
   ```bash
   git remote add origin https://gitlab.com/YOUR_USERNAME/terraform-infrastructure.git
   ```

3. **Push to GitLab:**
   ```bash
   git branch -M main
   git push -u origin main
   ```

### Option C: Other Git Hosting (Bitbucket, Azure DevOps, etc.)

Follow similar steps:
1. Create repository on your platform
2. Add remote: `git remote add origin <repository-url>`
3. Push: `git push -u origin main`

## Step 5: Verify CI/CD Pipeline

After pushing to GitHub:

1. Go to your repository on GitHub
2. Click on the **"Actions"** tab
3. You should see the workflow running automatically
4. Wait for it to complete - it should show ✅ (green checkmark) when successful

## Quick Setup Script

You can run these commands all at once (after creating the remote repo):

```bash
# Initialize git
git init

# Add all files
git add .

# Create initial commit
git commit -m "Initial commit: Modular Terraform infrastructure with CI/CD pipeline"

# Add remote (replace with your actual repository URL)
git remote add origin https://github.com/YOUR_USERNAME/REPO_NAME.git

# Rename branch to main
git branch -M main

# Push to remote
git push -u origin main
```

## Important Notes

### ⚠️ Security Considerations

1. **Terraform State Files:**
   - The `.gitignore` already excludes `*.tfstate` files
   - Never commit state files containing sensitive data

2. **Terraform Variables:**
   - Current `terraform.tfvars` files contain non-sensitive example values
   - If you add sensitive data (API keys, passwords), create separate files:
     - `secrets.tfvars` (add to .gitignore)
     - `terraform.tfvars.example` (commit this as a template)

3. **AWS Credentials:**
   - Never commit AWS credentials or access keys
   - Use environment variables or AWS IAM roles
   - For CI/CD, use GitHub Secrets (Settings → Secrets → Actions)

### 🔐 Setting Up GitHub Secrets for CI/CD

If you want the pipeline to actually deploy (not just validate), you'll need AWS credentials:

1. Go to your GitHub repository
2. Settings → Secrets and variables → Actions
3. Add the following secrets:
   - `AWS_ACCESS_KEY_ID`
   - `AWS_SECRET_ACCESS_KEY`
   - `AWS_REGION` (optional, defaults to eu-west-2)

Then update the workflow to use these secrets (currently it only validates, so credentials aren't needed).

## Branch Strategy (Optional)

For production use, consider this branching strategy:

```bash
# Create develop branch
git checkout -b develop
git push -u origin develop

# Create feature branch
git checkout -b feature/new-module
# ... make changes ...
git commit -m "Add new module"
git push -u origin feature/new-module
# Create PR on GitHub
```

## Troubleshooting

### Issue: "remote origin already exists"
```bash
# Remove existing remote
git remote remove origin
# Add new remote
git remote add origin <your-repo-url>
```

### Issue: "failed to push some refs"
```bash
# If remote has files (README, license, etc.), pull first:
git pull origin main --allow-unrelated-histories
# Then push
git push -u origin main
```

### Issue: Authentication failed
```bash
# For HTTPS, you may need a Personal Access Token
# For SSH, ensure your SSH key is added to GitHub/GitLab

# Check remote URL
git remote -v

# Update to use SSH if needed
git remote set-url origin git@github.com:USERNAME/REPO.git
```

## Next Steps After Pushing

1. ✅ **Verify CI/CD Pipeline:**
   - Check Actions tab - workflow should run automatically
   - Ensure validation passes

2. ✅ **Add Repository Description:**
   - Update GitHub repo description
   - Add topics/tags: `terraform`, `aws`, `infrastructure-as-code`, `ci-cd`

3. ✅ **Protect Main Branch (Recommended):**
   - Settings → Branches → Add rule for `main`
   - Require pull request reviews
   - Require status checks to pass

4. ✅ **Set Up Branch Protection:**
   - Require terraform validate to pass before merging

## Commands Reference

```bash
# Check status
git status

# View commit history
git log --oneline

# View remote
git remote -v

# Pull latest changes
git pull origin main

# Push changes
git push origin main

# Create and switch to new branch
git checkout -b feature-name

# Switch branches
git checkout main
```

## Success Checklist

- [ ] Git repository initialized
- [ ] All files committed
- [ ] Remote repository created (GitHub/GitLab/etc.)
- [ ] Remote added and pushed
- [ ] CI/CD pipeline running successfully
- [ ] Actions tab shows green checkmarks ✅

---

**Need help?** Check the [README.md](README.md) and [PIPELINE_GUIDE.md](PIPELINE_GUIDE.md) for more information.

