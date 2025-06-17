resource "aws_apigatewayv2_api" "http_api" {
  name          = "FastAPIHttpAPI"
  protocol_type = "HTTP"
  
  # Correct CORS configuration (built-in to aws_apigatewayv2_api)
  cors_configuration {
    allow_origins = ["https://d3f4nrxvf43e8.cloudfront.net"]
    allow_methods = ["GET", "POST", "OPTIONS"]
    allow_headers = ["*"]
    expose_headers = ["*"]
    max_age       = 300
  }
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