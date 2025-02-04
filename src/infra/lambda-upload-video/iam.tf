resource "aws_iam_role" "lambda_upload" {
  name = "lambda_upload_role"
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

data "aws_iam_policy_document" "lambda_upload" {
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
    effect    = "Allow"
    resources = ["*"]
    actions = [
      "dynamodb:InsertItem"
    ]
  }
}

resource "aws_iam_policy" "lambda_upload" {
  name   = "${local.component_name}-policy"
  policy = data.aws_iam_policy_document.lambda_upload.json
}

resource "aws_iam_role_policy_attachment" "lambda_upload_attach" {
  policy_arn = aws_iam_policy.lambda_upload.arn
  role       = aws_iam_role.lambda_upload.name
}
