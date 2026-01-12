# Terraform Infrastructure as Code

This repository contains modular Terraform code for deploying AWS infrastructure across multiple environments (dev/prod).

## 📁 Project Structure

```
terraform/
├── modules/
│   ├── vpc/              # VPC, subnets, internet gateway, route tables
│   ├── ec2-instance/     # EC2 instances module
│   └── security-group/   # Security groups module
├── environments/
│   ├── dev/              # Development environment
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   ├── outputs.tf
│   │   └── terraform.tfvars
│   └── prod/             # Production environment
│       ├── main.tf
│       ├── variables.tf
│       ├── outputs.tf
│       └── terraform.tfvars
└── .github/
    └── workflows/
        └── terraform-validate.yml
```

## 🚀 Quick Start

### Prerequisites

- Terraform >= 1.2.2
- AWS CLI configured with appropriate credentials
- Access to AWS account

### Initialize Terraform

```bash
cd environments/dev
terraform init
```

### Validate Configuration

```bash
terraform validate
terraform fmt -check
```

### Plan Changes

```bash
terraform plan -var-file=terraform.tfvars
```

### Apply Changes

```bash
terraform apply -var-file=terraform.tfvars
```

## 🔧 Modules

### VPC Module
Creates VPC, public subnets across multiple AZs, internet gateway, and route tables.

**Usage:**
```hcl
module "vpc" {
  source = "../../modules/vpc"
  
  environment         = "dev"
  vpc_cidr            = "10.0.0.0/16"
  public_subnet_cidrs = ["10.0.1.0/24", "10.0.2.0/24"]
  availability_zones  = ["eu-west-2a", "eu-west-2b"]
  tags                = local.common_tags
}
```

### Security Group Module
Creates security groups with configurable ingress and egress rules.

**Usage:**
```hcl
module "security_group" {
  source = "../../modules/security-group"
  
  environment = "dev"
  name        = "web-sg"
  vpc_id      = module.vpc.vpc_id
  
  ingress_rules = [
    {
      from_port   = 8080
      to_port     = 8080
      protocol    = "tcp"
      cidr_blocks = ["10.0.0.0/16"]
    }
  ]
  
  egress_rules = [
    {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]
}
```

### EC2 Instance Module
Creates EC2 instances with configurable count, instance types, and user data.

**Usage:**
```hcl
module "web_instances" {
  source = "../../modules/ec2-instance"
  
  environment        = "dev"
  name_prefix        = "web"
  instance_count     = 3
  instance_type      = "t2.micro"
  subnet_ids         = module.vpc.public_subnet_ids
  security_group_ids = [module.security_group.security_group_id]
}
```

## 🔄 CI/CD Pipeline

The repository includes a GitHub Actions workflow that automatically:

1. **Validates Terraform syntax** for all modules and environments
2. **Checks code formatting** using `terraform fmt`
3. **Runs linting** using `tflint`

The pipeline runs on:
- Push to `main` or `develop` branches
- Pull requests to `main` or `develop`
- Manual workflow dispatch

### View Pipeline Status

Navigate to the "Actions" tab in GitHub to view pipeline runs and results.

## 🔒 Security Improvements

This refactored code addresses the following security concerns from the original:

- ✅ **Restricted security group rules** - Only specific ports and VPC CIDR blocks
- ✅ **Explicit egress rules** - Defined outbound traffic rules
- ✅ **Multi-AZ deployment** - High availability across availability zones
- ✅ **Resource tagging** - Proper tagging for cost tracking and management
- ✅ **Dynamic AMI lookup** - Uses latest Amazon Linux 2 AMI instead of hardcoded IDs

## 📝 Environment Configuration

### Development Environment
- Instance type: `t2.micro`
- VPC CIDR: `10.0.0.0/16`
- Instance count: 3

### Production Environment
- Instance type: `t3.large`
- VPC CIDR: `10.1.0.0/16`
- Instance count: 3

## 🛠️ Development Workflow

1. Make changes to modules or environments
2. Run `terraform fmt` to format code
3. Run `terraform validate` to check syntax
4. Create a pull request
5. CI/CD pipeline will automatically validate changes
6. After approval, merge to main branch

## 📚 Additional Resources

- [Terraform AWS Provider Documentation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)
- [Terraform Best Practices](https://www.terraform.io/docs/cloud/guides/recommended-practices/index.html)
- [AWS Well-Architected Framework](https://aws.amazon.com/architecture/well-architected/)

## 🤝 Contributing

1. Create a feature branch
2. Make your changes
3. Ensure `terraform validate` passes
4. Submit a pull request

## 📄 License

This project is for educational/demonstration purposes.
