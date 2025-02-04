resource "aws_cloudwatch_log_group" "lambda_upload" {
  name              = "/aws/lambda/${aws_lambda_function.lambda_upload.function_name}"
  retention_in_days = 3
}
