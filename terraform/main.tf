# -----------------------------
# terraform/main.tf (ROOT MODULE)
# -----------------------------

module "backend" {
  source              = "./modules/backend"
  lambda_zip_path     = "../backend/fastapi.zip"
  subnet_ids          = var.subnet_ids
  security_group_ids  = var.security_group_ids
}

module "apigateway" {
  source              = "./modules/apigateway"
  lambda_function_arn = module.backend.lambda_function_arn
  lambda_invoke_arn   = module.backend.lambda_invoke_arn
}

module "frontend" {
  source      = "./modules/frontend"
  bucket_name = var.bucket_name
  account_id  = data.aws_caller_identity.current.account_id
}

