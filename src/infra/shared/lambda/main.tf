resource "aws_lambda_function" "lambda" {
  function_name    = var.lambda_name
  filename         = var.lambda_output_path
  source_code_hash = filebase64sha256(var.lambda_output_path)
  role             = var.lambda_iam_role_to_assume_arn
  handler          = var.lambda_handler
  runtime          = var.lambda_runtime
  architectures    = var.lambda_arch
  timeout          = var.lambda_timeout
  memory_size      = var.lambda_memsize
  layers           = var.lambda_layers

  ephemeral_storage {
    size = var.lambda_ephemeral_storage
  }

  environment {
    variables = var.lambda_environment
  }
}

resource "aws_cloudwatch_log_group" "log_group" {
  name = "/aws/lambda/${var.lambda_name}"
  retention_in_days = 3
}