resource "aws_cloudwatch_log_group" "lambda_status" {
  name              = "/aws/lambda/${aws_lambda_function.lambda_status.function_name}"
  retention_in_days = 3
}
