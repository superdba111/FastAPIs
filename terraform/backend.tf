terraform {
  backend "s3" {
    bucket         = "nws-dl-terraform-statefile-1"  # Your existing state bucket
    key            = "poc/data-lake-api-gateway.tfstate"  # Unique key for this project
    region         = "us-east-1"
    dynamodb_table = "nws-dl-terraform-lock-1"  # Your existing lock table
    encrypt        = true
  }
}