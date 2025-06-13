output "lambda_function_arn" {
  value = aws_lambda_function.fastapi.arn
}

output "lambda_invoke_arn" {
  value = aws_lambda_function.fastapi.invoke_arn
}
