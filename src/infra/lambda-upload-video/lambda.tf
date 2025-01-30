data "archive_file" "upload_lambda" {
  type        = "zip"
  source_dir  = local.lambdas_path
  output_path = "files/${local.component_name}-artefact.zip"
}

resource "aws_lambda_function" "upload_lambda" {
  filename         = data.archive_file.upload_lambda.output_path
  function_name    = local.component_name
  role             = aws_iam_role.upload_lambda.arn
  handler          = "index.handler"
  runtime          = "nodejs16.x"
  source_code_hash = data.archive_file.upload_lambda.output_base64sha256
  architectures    = ["arm64"]

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
  compatible_runtimes = ["nodejs16.x"]

  #s3_bucket = var.bucket_name_ffmpeg
  #s3_key    = var.object_key_ffmpeg
}*/