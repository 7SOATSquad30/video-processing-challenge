resource "aws_iam_role" "lambda_status" {
  name = "lambda_status_role"
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

data "aws_iam_policy_document" "lambda_status" {
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
}

resource "aws_iam_policy" "lambda_status" {
  name   = "${local.component_name}-policy"
  policy = data.aws_iam_policy_document.lambda_status.json
}

resource "aws_iam_role_policy_attachment" "lambda_status_attach" {
  policy_arn = aws_iam_policy.lambda_status.arn
  role       = aws_iam_role.lambda_status.name
}
