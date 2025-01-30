data "archive_file" "upload_lambda" {
  type        = "zip"
  source_dir  = local.lambdas_path
  output_path = "files/${local.component_name}-artefact.zip"
}

resource "aws_lambda_function" "upload_lambda" {
  filename         = data.archive_file.upload_lambda.output_path
  function_name    = local.component_name
  role             = aws_iam_role.upload_lambda.arn
  handler          = "lambda.handler"
  runtime          = "nodejs16.x"
  source_code_hash = data.archive_file.upload_lambda.output_base64sha256
  architectures    = ["arm64"]

  environment {
    variables = {
      DYNAMODB_TABLE_NAME = var.dynamodb_table_name
      INPUT_S3_BUCKET    = var.input_s3_bucket
    }
  }
}