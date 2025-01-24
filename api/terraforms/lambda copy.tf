provider "aws" {
  region = "us-east-1"
}

data "archive_file" "upload_lambda" {
    type = "zip"
    source_dir = "${local.lambdas_path}/dist"
    output_path = "files/${local.component_name}-artefact.zip"
}

resource "aws_lambda_function" "upload_lambda" {
  filename         = "${path.module}/dist/lambda.js"
  function_name    = "uploadLambda"
  role             = aws_iam_role.lambda_exec.arn
  handler          = "lambda.handler"
  runtime          = "nodejs14.x"
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

resource "aws_iam_role_policy_attachment" "lambda_exec_attach" {
  role       = aws_iam_role.lambda_exec.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}
