# Quick Start: Push to Git Repository

## 🚀 Fastest Way (Automated Script)

Run the setup script:

```bash
./setup-git.sh
```

The script will guide you through:
1. Initializing Git
2. Creating initial commit
3. Setting up remote (GitHub/GitLab)
4. Pushing to remote

## 📝 Manual Steps (5 minutes)

### 1. Initialize Git
```bash
git init
```

### 2. Add Files
```bash
git add .
```

### 3. Create Commit
```bash
git commit -m "Initial commit: Modular Terraform infrastructure with CI/CD pipeline"
```

### 4. Create Repository on GitHub
- Go to https://github.com/new
- Name: `terraform-infrastructure` (or your choice)
- **Don't** initialize with README
- Click "Create repository"

### 5. Connect and Push
```bash
# Add remote (replace with your username and repo name)
git remote add origin https://github.com/YOUR_USERNAME/terraform-infrastructure.git

# Rename branch
git branch -M main

# Push
git push -u origin main
```

## ✅ Verify Success

1. Go to your GitHub repository
2. Click **"Actions"** tab
3. You should see the workflow running
4. Wait for ✅ (green checkmark) - validation passed!

## 📚 More Details

See [GIT_SETUP.md](GIT_SETUP.md) for:
- Detailed instructions
- Troubleshooting
- Security considerations
- Branch protection setup

