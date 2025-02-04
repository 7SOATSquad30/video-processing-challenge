
output "lambda" {
  value = {
    arn        = aws_lambda_function.lambda_status.arn
    name       = aws_lambda_function.lambda_status.function_name
    invoke_arn = aws_lambda_function.lambda_status.invoke_arn
  }
}