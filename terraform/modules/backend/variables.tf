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

variable "api_gateway_execution_arn" {
  description = "The execution ARN of the API Gateway"
  type        = string
}