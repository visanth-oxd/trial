# CI/CD Pipeline Guide

## Overview

This repository includes GitHub Actions workflows that automatically validate Terraform code on every push and pull request.

## Available Workflows

### 1. `terraform-validate.yml`
**Purpose:** Comprehensive validation with formatting and linting

**Triggers:**
- Push to `main` or `develop` branches
- Pull requests to `main` or `develop`
- Manual workflow dispatch

**Jobs:**
- **terraform-validate**: Validates syntax for all modules and environments
- **terraform-lint**: Runs tflint for code quality checks

### 2. `test-validation.yml`
**Purpose:** Simple validation test that demonstrates successful validation

**Triggers:**
- Push to any branch
- Pull requests to any branch
- Manual workflow dispatch

**What it does:**
1. Checks Terraform formatting
2. Initializes Terraform (without backend)
3. Validates syntax for each environment (dev/prod)
4. Validates all modules
5. Shows success message

## Testing the Pipeline Locally

### Prerequisites
```bash
# Install Terraform (if not already installed)
# macOS
brew install terraform

# Or download from https://www.terraform.io/downloads
```

### Manual Validation

#### Option 1: Using the validation script
```bash
./validate.sh
```

#### Option 2: Using Makefile
```bash
# Validate all
make validate-all

# Validate specific environment
make validate-dev
make validate-prod

# Validate modules only
make validate-modules
```

#### Option 3: Manual commands
```bash
# Validate dev environment
cd environments/dev
terraform init -backend=false
terraform validate

# Validate prod environment
cd ../prod
terraform init -backend=false
terraform validate

# Validate a module
cd ../../modules/vpc
terraform init -backend=false
terraform validate
```

## Pipeline Status

### Viewing Pipeline Runs

1. Navigate to your GitHub repository
2. Click on the "Actions" tab
3. Select the workflow run to view details
4. Check individual job status

### Expected Success Output

When the pipeline runs successfully, you should see:

```
✓ Format check passed
✓ Initialization successful
✓ Validation successful for dev environment
✓ Validation successful for prod environment
✓ Module validation passed: modules/vpc
✓ Module validation passed: modules/ec2-instance
✓ Module validation passed: modules/security-group
✓ All Terraform validations passed!
Status: SUCCESS ✅
```

## Troubleshooting

### Pipeline Fails on Format Check

**Solution:** Run `terraform fmt -recursive` locally and commit the changes.

```bash
make fmt
# or
terraform fmt -recursive
```

### Pipeline Fails on Validation

**Common causes:**
1. Syntax errors in Terraform files
2. Missing required variables
3. Invalid module references

**Solution:**
1. Check the error message in the pipeline logs
2. Run `terraform validate` locally to reproduce
3. Fix the issues and push again

### Module Not Found Errors

**Solution:** Ensure module paths are correct:
- Modules should be in `modules/` directory
- Environment configs should reference modules with `../../modules/`

## Adding New Environments

To add a new environment (e.g., `staging`):

1. Create `environments/staging/` directory
2. Copy files from `environments/dev/` as template
3. Update `terraform.tfvars` with staging-specific values
4. The pipeline will automatically validate the new environment

## Customizing the Pipeline

### Adding More Validation Steps

Edit `.github/workflows/terraform-validate.yml`:

```yaml
- name: Custom Validation
  run: |
    # Your custom validation commands
    echo "Running custom checks..."
```

### Changing Terraform Version

Update the `TF_VERSION` environment variable in the workflow file:

```yaml
env:
  TF_VERSION: "1.6.0"  # Change version here
```

## Best Practices

1. **Always validate locally** before pushing
2. **Run `terraform fmt`** to ensure consistent formatting
3. **Check pipeline status** before merging PRs
4. **Review validation errors** carefully
5. **Keep Terraform version** consistent across team

## Next Steps

After validation passes, you can:
1. Run `terraform plan` to see what will be created
2. Run `terraform apply` to deploy infrastructure
3. Set up additional pipeline stages for:
   - Terraform plan (dry-run)
   - Security scanning (checkov, tfsec)
   - Cost estimation (infracost)

