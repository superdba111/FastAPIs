# terraform/variables.tf
variable "subnet_ids" {
  type        = list(string)
  description = "List of subnet IDs for Lambda VPC configuration"
}

variable "security_group_ids" {
  type        = list(string)
  description = "List of security group IDs for Lambda VPC configuration"
}

variable "bucket_name" {
  type        = string
  description = "Name of the S3 bucket for frontend hosting"
}

# Optional: Add region if needed
variable "region" {
  type        = string
  default     = "us-east-1"
  description = "AWS region for resources"
}