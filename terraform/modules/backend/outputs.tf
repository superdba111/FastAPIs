output "lambda_function_arn" {
  value = aws_lambda_function.fastapi.arn
}

output "lambda_invoke_arn" {
  value = aws_lambda_function.fastapi.invoke_arn
}

# Add if you need the function name
output "lambda_function_name" {
  value = aws_lambda_function.fastapi.function_name
}

