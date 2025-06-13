variable "lambda_function_arn" {
  type        = string
  description = "ARN of the Lambda function to be triggered"
}

variable "lambda_invoke_arn" {
  type        = string
  description = "Invoke ARN of the Lambda function"
}
