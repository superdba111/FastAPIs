resource "aws_apigatewayv2_api" "http_api" {
  name          = "FastAPIHttpAPI"
  protocol_type = "HTTP"
  target        = aws_lambda_function.fastapi.arn
}

# Add a CORS configuration to your API Gateway HTTP API
resource "aws_apigatewayv2_cors_configuration" "default" {
  api_id = aws_apigatewayv2_api.http_api.id

  # This needs to be the exact origin of your frontend (your CloudFront URL)
  # Or use ["*"] for development/testing, but be more specific for production.
  allow_origins = ["https://d3f4nrxvf43e8.cloudfront.net"]
  # If you use a custom domain for CloudFront, use that: allow_origins = ["https://your-custom-frontend-domain.com"]

  allow_methods = ["GET", "POST", "PUT", "DELETE", "OPTIONS"] # Include all methods your API uses, plus OPTIONS
  allow_headers = ["content-type", "x-amz-date", "authorization", "x-api-key", "x-amz-security-token", "x-amz-user-agent"] # Common headers
  max_age       = 300 # How long the browser can cache the preflight response (in seconds)
}

resource "aws_apigatewayv2_integration" "lambda_integration" {
  api_id                    = aws_apigatewayv2_api.http_api.id
  integration_type          = "AWS_PROXY"
  integration_uri           = var.lambda_invoke_arn
  integration_method        = "POST"
  payload_format_version    = "2.0"
}

resource "aws_apigatewayv2_route" "fastapi_route" {
  api_id    = aws_apigatewayv2_api.http_api.id
  route_key = "$default"
  target    = "integrations/${aws_apigatewayv2_integration.lambda_integration.id}"
}

resource "aws_apigatewayv2_stage" "default_stage" {
  api_id      = aws_apigatewayv2_api.http_api.id
  name        = "$default"
  auto_deploy = true
}

resource "aws_lambda_permission" "apigw_lambda" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = var.lambda_function_arn
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.http_api.execution_arn}/*/*"
}
