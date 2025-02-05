output "lambda" {
  value = {
    arn        = module.lambda.lambda_arn
    name       = module.lambda.lambda_name
    invoke_arn = module.lambda.lambda_invoke_arn
  }
}
