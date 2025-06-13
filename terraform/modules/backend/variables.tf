variable "lambda_zip_path" {
  type        = string
  description = "Path to the zipped FastAPI application"
}

variable "subnet_ids" {
  type        = list(string)
  description = "List of subnet IDs for Lambda VPC config"
}

variable "security_group_ids" {
  type        = list(string)
  description = "List of security group IDs for Lambda VPC config"
}