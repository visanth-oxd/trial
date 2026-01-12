output "vpc_id" {
  description = "VPC ID"
  value       = module.vpc.vpc_id
}

output "vpc_cidr_block" {
  description = "VPC CIDR block"
  value       = module.vpc.vpc_cidr_block
}

output "public_subnet_ids" {
  description = "Public subnet IDs"
  value       = module.vpc.public_subnet_ids
}

output "security_group_id" {
  description = "Security group ID"
  value       = module.security_group.security_group_id
}

output "instance_ids" {
  description = "EC2 instance IDs"
  value       = module.web_instances.instance_ids
}

output "instance_public_ips" {
  description = "Public IP addresses of EC2 instances"
  value       = module.web_instances.instance_public_ips
}

output "instance_private_ips" {
  description = "Private IP addresses of EC2 instances"
  value       = module.web_instances.instance_private_ips
}

