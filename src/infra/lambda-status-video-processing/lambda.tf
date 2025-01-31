data "archive_file" "lambda_status" {
  type        = "zip"
  source_dir  = local.lambdas_path
  output_path = "files/${local.component_name}-artefact.zip"
}

resource "aws_lambda_function" "lambda_status" {
  filename         = data.archive_file.lambda_status.output_path
  function_name    = local.component_name
  role             = aws_iam_role.lambda_status.arn
  handler          = "index.handler"
  runtime          = "nodejs16.x"
  source_code_hash = data.archive_file.lambda_status.output_base64sha256
  architectures    = ["arm64"]
  timeout          = 900
  memory_size      = 512

  environment {
    variables = {
      DYNAMODB_TABLE_NAME = var.dynamodb_table_name
    }
  }
}
