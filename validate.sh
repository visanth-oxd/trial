#!/bin/bash

# Terraform Validation Script
# This script validates all Terraform modules and environments

set -e

echo "=========================================="
echo "Terraform Validation Script"
echo "=========================================="
echo ""

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Check if terraform is installed
if ! command -v terraform &> /dev/null; then
    echo -e "${RED}Error: Terraform is not installed${NC}"
    echo "Please install Terraform >= 1.2.2"
    exit 1
fi

TERRAFORM_VERSION=$(terraform version -json | jq -r '.terraform_version')
echo -e "${GREEN}Terraform version: ${TERRAFORM_VERSION}${NC}"
echo ""

# Function to validate a directory
validate_directory() {
    local dir=$1
    local name=$2
    
    echo -e "${YELLOW}Validating ${name}...${NC}"
    cd "$dir"
    
    # Initialize
    echo "  Initializing..."
    if ! terraform init -backend=false -input=false > /dev/null 2>&1; then
        echo -e "  ${RED}✗ Initialization failed${NC}"
        terraform init -backend=false -input=false
        return 1
    fi
    
    # Format check
    echo "  Checking format..."
    if ! terraform fmt -check -recursive > /dev/null 2>&1; then
        echo -e "  ${YELLOW}⚠ Formatting issues found. Run 'terraform fmt' to fix.${NC}"
    else
        echo -e "  ${GREEN}✓ Format is correct${NC}"
    fi
    
    # Validate
    echo "  Validating syntax..."
    if terraform validate -no-color; then
        echo -e "  ${GREEN}✓ Validation passed${NC}"
        echo ""
        return 0
    else
        echo -e "  ${RED}✗ Validation failed${NC}"
        echo ""
        return 1
    fi
}

# Track validation results
VALIDATION_FAILED=0

# Validate modules
echo "=========================================="
echo "Validating Modules"
echo "=========================================="
echo ""

for module in modules/*/; do
    if [ -d "$module" ]; then
        MODULE_NAME=$(basename "$module")
        if ! validate_directory "$module" "module: $MODULE_NAME"; then
            VALIDATION_FAILED=1
        fi
        cd - > /dev/null
    fi
done

# Validate environments
echo "=========================================="
echo "Validating Environments"
echo "=========================================="
echo ""

for env in environments/*/; do
    if [ -d "$env" ]; then
        ENV_NAME=$(basename "$env")
        if ! validate_directory "$env" "environment: $ENV_NAME"; then
            VALIDATION_FAILED=1
        fi
        cd - > /dev/null
    fi
done

# Summary
echo "=========================================="
echo "Validation Summary"
echo "=========================================="
echo ""

if [ $VALIDATION_FAILED -eq 0 ]; then
    echo -e "${GREEN}✓ All validations passed!${NC}"
    exit 0
else
    echo -e "${RED}✗ Some validations failed${NC}"
    exit 1
fi

