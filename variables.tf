# variables.tf

variable "aws_region" {
  description = "The AWS region to deploy to"
  type        = string
  default     = "ap-northeast-3"
}

variable "project_name" {
  description = "Project name prefix for tagging"
  type        = string
  default     = "two-tier-app"
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidr" {
  description = "CIDR block for Public Subnet"
  type        = string
  default     = "10.0.1.0/24"
}

variable "private_subnet_cidr" {
  description = "CIDR block for Private Subnet"
  type        = string
  default     = "10.0.2.0/24"
}

variable "db_password" {
  description = "The password for the RDS database"
  type        = string
  sensitive   = true
}
