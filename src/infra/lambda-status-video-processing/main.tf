terraform {
  backend "s3" {
    bucket  = "fiap-challenge-terraform-state"
    key     = "video-processing-challenge/lambda-status-video-processing.tfstate"
    region  = "us-east-1"
    encrypt = true
  }
}

provider "aws" {
  region = var.aws_region
  s3_use_path_style = var.s3_use_path_style
}


module "iam" {
  source = "./iam"
  lambda_name = var.lambda_name
}

module "lambda" {
  source = "./lambda"
  lambda_name = var.lambda_name
  lambda_iam_role_to_assume_arn = module.iam.lambda_iam_role_to_assume_arn
  dynamodb_table_name = var.dynamodb_table_name
}

module "api_gateway" {
  source = "./api_gateway"
  lambda_name = var.lambda_name
  lambda_invoke_arn = module.lambda.lambda_invoke_arn
}