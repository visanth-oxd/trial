terraform {
  required_version = ">= 1.2.2"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.9.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

# Common tags
locals {
  common_tags = {
    Environment = "dev"
    Project     = "web-application"
    ManagedBy   = "Terraform"
    Owner       = "DevOps-Team"
  }
}

# VPC Module
module "vpc" {
  source = "../../modules/vpc"

  environment         = "dev"
  vpc_cidr            = var.vpc_cidr
  public_subnet_cidrs = var.public_subnet_cidrs
  availability_zones  = var.availability_zones
  tags                = local.common_tags
}

# Security Group Module
module "security_group" {
  source = "../../modules/security-group"

  environment = "dev"
  name        = "web-sg"
  description = "Security group for web instances in dev environment"
  vpc_id      = module.vpc.vpc_id

  ingress_rules = [
    {
      from_port   = 8080
      to_port     = 8080
      protocol    = "tcp"
      cidr_blocks = [var.vpc_cidr]
      description = "Application port from VPC"
    },
    {
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
      description = "HTTPS access"
    }
  ]

  egress_rules = [
    {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
      description = "Allow all outbound traffic"
    }
  ]

  tags = local.common_tags
}

# EC2 Instances Module
module "web_instances" {
  source = "../../modules/ec2-instance"

  environment         = "dev"
  name_prefix         = "web"
  instance_count      = 3
  instance_type       = var.instance_type
  subnet_ids          = module.vpc.public_subnet_ids
  security_group_ids  = [module.security_group.security_group_id]
  associate_public_ip = true

  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              yum install -y httpd
              systemctl start httpd
              systemctl enable httpd
              echo "<h1>Hello from Dev Environment - $(hostname)</h1>" > /var/www/html/index.html
              EOF

  tags = local.common_tags
}

