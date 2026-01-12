variable "environment" {
  description = "Environment name (dev/prod)"
  type        = string
}

variable "name_prefix" {
  description = "Prefix for instance names"
  type        = string
  default     = "web"
}

variable "instance_count" {
  description = "Number of instances to create"
  type        = number
  default     = 1
}

variable "ami_id" {
  description = "AMI ID to use. If null, will use latest Amazon Linux 2"
  type        = string
  default     = null
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t2.micro"
}

variable "subnet_ids" {
  description = "List of subnet IDs to deploy instances to"
  type        = list(string)
}

variable "security_group_ids" {
  description = "List of security group IDs"
  type        = list(string)
}

variable "associate_public_ip" {
  description = "Whether to associate a public IP address"
  type        = bool
  default     = true
}

variable "user_data" {
  description = "User data script"
  type        = string
  default     = ""
}

variable "user_data_replace_on_change" {
  description = "Whether to replace instance when user_data changes"
  type        = bool
  default     = true
}

variable "tags" {
  description = "Common tags to apply to all resources"
  type        = map(string)
  default     = {}
}

