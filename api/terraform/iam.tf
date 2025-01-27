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

data "aws_iam_policy_document" "s3_lambda" {
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
    resources = ["arn:aws:s3:::${aws_s3_bucket.lambda.id}/*"]
    actions   = ["s3:GetObject", "s3:PutObject", "s3:PutBucketAcl"]
  }
}

resource "aws_iam_policy" "upload_lambda" {
  name   = "${local.component_name}-policy"
  policy = data.aws_iam_policy_document.s3_lambda.json
}

resource "aws_iam_role_policy_attachment" "upload_lambda_attach" {
  policy_arn = aws_iam_policy.upload_lambda.arn
  role       = aws_iam_role.upload_lambda.name
}
