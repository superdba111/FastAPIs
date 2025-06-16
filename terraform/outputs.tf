output "api_url" {
  description = "URL of the API Gateway"
  value       = module.apigateway.api_gateway_url
}

output "frontend_url" {
  description = "CloudFront distribution URL for the frontend"
  value       = module.frontend.cloudfront_url
}

# Corrected Lambda output (use the actual output from backend module)
output "lambda_function_arn" {
  description = "ARN of the Lambda function"
  value       = module.backend.lambda_function_arn
}

output "cloudfront_distribution_id" {
  description = "ID of the CloudFront distribution"
  value       = module.frontend.cloudfront_distribution_id
}

output "s3_bucket_name" {
  description = "Name of the S3 bucket for the frontend static files"
  value       = var.bucket_name 