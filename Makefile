.PHONY: help init validate fmt fmt-check clean validate-dev validate-prod validate-all

help: ## Show this help message
	@echo 'Usage: make [target]'
	@echo ''
	@echo 'Available targets:'
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-20s\033[0m %s\n", $$1, $$2}'

init-dev: ## Initialize Terraform for dev environment
	cd environments/dev && terraform init

init-prod: ## Initialize Terraform for prod environment
	cd environments/prod && terraform init

init-all: init-dev init-prod ## Initialize Terraform for all environments

validate-dev: ## Validate dev environment
	cd environments/dev && terraform init -backend=false && terraform validate

validate-prod: ## Validate prod environment
	cd environments/prod && terraform init -backend=false && terraform validate

validate-modules: ## Validate all modules
	@for module in modules/*/; do \
		echo "Validating $$module"; \
		cd $$module && terraform init -backend=false && terraform validate && cd -; \
	done

validate-all: validate-modules validate-dev validate-prod ## Validate all modules and environments

fmt: ## Format all Terraform files
	terraform fmt -recursive

fmt-check: ## Check Terraform formatting
	terraform fmt -check -recursive

clean: ## Clean Terraform files
	find . -type d -name ".terraform" -exec rm -rf {} + 2>/dev/null || true
	find . -type f -name ".terraform.lock.hcl" -delete 2>/dev/null || true

plan-dev: ## Plan dev environment
	cd environments/dev && terraform plan -var-file=terraform.tfvars

plan-prod: ## Plan prod environment
	cd environments/prod && terraform plan -var-file=terraform.tfvars

