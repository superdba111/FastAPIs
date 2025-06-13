resource "aws_iam_role" "lambda_exec" {
  name = "lambda_exec_role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_lambda_function" "fastapi" {
  function_name    = "fastapiHandler"
  filename         = var.lambda_zip_path
  handler          = "main.handler"
  runtime          = "python3.11"
  role             = aws_iam_role.lambda_exec.arn
  source_code_hash = filebase64sha256(var.lambda_zip_path)
}
