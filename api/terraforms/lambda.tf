provider "aws" {
  region = "us-east-1"
}

data "archive_file" "upload_lambda" {
  type        = "zip"
  source_dir  = "${local.lambdas_path}/dist"
  output_path = "files/${local.component_name}-artefact.zip"
}

resource "aws_lambda_function" "upload_lambda" {
  function_name    = local.component_name
  role             = aws_iam_role.lambda_exec.arn
  runtime          = "nodejs16.x"
  architectures    = ["arm64"]
  handler          = "lambda.handler"
  filename         = data.archive_file.upload_lambda.output_path
  source_code_hash = data.archive_file.upload_lambda.output_base64sha256
}

resource "aws_lambda_permission" "s3" {
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.upload_lambda.function_name
  principal     = "s3.amazonaws.com"
  source_arn    = aws_s3_bucket.lambda.arn
}

resource "aws_iam_role" "lambda_exec" {
  name = "lambda_exec_role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action = "sts:AssumeRole",
      Effect = "Allow",
      Sid    = "",
      Principal = {
        Service = "lambda.amazonaws.com"
      },
    }],
  })
}

data "aws_iam_policy_document" "s3_lambda" {
  statement {
    effect    = "Allow"
    resources = ["arn:aws:logs:*:*"]
    actions   = ["logs:CreateLogGroup"]
  }

  statement {
    sid       = ["AllowWritingLogs"]
    effect    = "Allow"
    resources = ["arn:aws:logs:*:*:log-group:/aws/lambda/*:*"]
    actions   = ["logs:CreateLogStream", "logs:PutLogEvents"]
  }

  statement {
    effect    = "Allow"
    resources = ["arn:aws:s3:::${aws_s3_bucket.lambda.id}/*"]
    actions   = ["s3:GetObject"]
  }
}

resource "aws_iam_policy" "upload_lambda" {
  name   = "${local.component_name}-policy"
  policy = data.aws_iam_policy_document.s3_lambda.json
}

resource "aws_iam_role_policy_attachment" "lambda_exec_attach" {
  policy_arn = aws_iam_policy.upload_lambda.arn
  role       = aws_iam_role.upload_lambda.name
}

resource "aws_s3_bucket_notification" "upload_lambda_trigger" {
  bucket = aws_s3_bucket.lambda.id

  lambda_function {
    events              = ["s3:ObjectCreated:*"]
    filter_prefix       = "input/images"
    filter_suffix       = ".jpg"
    lambda_function_arn = aws_lambda_function.upload_lambda.arn
  }
}