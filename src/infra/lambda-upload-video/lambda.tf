data "archive_file" "lambda_upload" {
  type        = "zip"
  source_dir  = local.lambdas_path
  output_path = "files/${local.component_name}-artefact.zip"
}

/*
data "archive_file" "lambda_upload" {
  type        = "zip"
  #source_dir  = local.lambdas_path
  output_path = "files/${local.component_name}-artefact.zip"
  source {
    content  = "${file("${local.lambdas_path}/node_modules")}"
    filename = "node_modules"
  }
  source {
    content  = "${file("${local.lambdas_path}/dist")}"
  }
}*/

resource "aws_lambda_function" "lambda_upload" {
  filename         = data.archive_file.lambda_upload.output_path
  function_name    = local.component_name
  role             = aws_iam_role.lambda_upload.arn
  handler          = "index.handler"
  runtime          = "nodejs20.x"
  source_code_hash = data.archive_file.lambda_upload.output_base64sha256
  architectures    = ["arm64"]
  timeout          = 900
  memory_size      = 512

  /*layers = [
    aws_lambda_layer_version.express_layer.arn
  ]*/

  environment {
    variables = {
      DYNAMODB_TABLE_NAME = var.dynamodb_table_name
      INPUT_S3_BUCKET     = var.input_s3_bucket
    }
  }
}

/*resource "aws_lambda_layer_version" "express_layer" {
  layer_name          = "express-layer"
  description         = "Nodejs Express Layer"
  compatible_runtimes = ["nodejs20.x"]

  #s3_bucket = var.bucket_name_ffmpeg
  #s3_key    = var.object_key_ffmpeg
}*/