output "api_gateway_url" {
  value = aws_apigatewayv2_api.http_api.api_endpoint
}

output "api_execution_arn" {
  description = "The execution ARN of the API Gateway"
  value       = aws_api_gateway_rest_api.this.execution_arn
}