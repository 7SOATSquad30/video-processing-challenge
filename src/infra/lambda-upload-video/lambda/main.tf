data "archive_file" "deployment_archive" {
  type        = "zip"
  source_dir  = "../../lambda-upload-video"
  output_path = "../../lambda-upload-video/build.zip"
}

resource "aws_lambda_function" "lambda" {
  function_name    = var.lambda_name
  filename         = data.archive_file.deployment_archive.output_path
  source_code_hash = data.archive_file.deployment_archive.output_base64sha256
  role             = var.lambda_iam_role_to_assume_arn
  handler          = "dist/index.handler"
  runtime          = "nodejs20.x"
  architectures    = ["arm64"]
  timeout          = 900
  memory_size      = 512

  environment {
    variables = {
      DYNAMODB_TABLE_NAME = var.dynamodb_table_name
      INPUT_S3_BUCKET     = var.input_s3_bucket
    }
  }
}

resource "aws_cloudwatch_log_group" "log_group" {
  name = "/aws/lambda/${var.lambda_name}"
  retention_in_days = 3
}