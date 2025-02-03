resource "aws_iam_role" "upload_lambda" {
  name = "upload_lambda_role"
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

data "aws_iam_policy_document" "upload_lambda" {
  statement {
    effect    = "Allow"
    resources = ["arn:aws:logs:*:*"]
    actions   = ["logs:CreateLogGroup"]
  }

  statement {
    sid       = "AllowWritingLogs"
    effect    = "Allow"
    resources = ["arn:aws:logs:*:*:log-group:/aws/lambda/*:*"]
    actions   = ["logs:CreateLogStream", "logs:PutLogEvents"]
  }

  statement {
    effect    = "Allow"
    resources = ["*"]
    actions   = ["s3:GetObject", "s3:PutObject", "s3:PutBucketAcl"]
  }

  statement {
    effect    = "Allow"
    resources = ["arn:aws:sqs:us-east-1:123456789012:${var.sqs_queue_name}"]
    actions   = ["sqs:SendMessage"]
  }

  statement {
    sid       = "AllowDynamoDBQuery"
    effect   = "Allow"
    resources = ["*"]
    actions = [
      "dynamodb:InsertItem"
    ]
  }
}

resource "aws_iam_policy" "upload_lambda" {
  name   = "${local.component_name}-policy"
  policy = data.aws_iam_policy_document.upload_lambda.json
}

resource "aws_iam_role_policy_attachment" "upload_lambda_attach" {
  policy_arn = aws_iam_policy.upload_lambda.arn
  role       = aws_iam_role.upload_lambda.name
}
