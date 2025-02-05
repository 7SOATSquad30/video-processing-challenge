resource "aws_iam_role" "role" {
  name = "${var.lambda_name}_role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action = "sts:AssumeRole",
      Effect = "Allow",
      Sid    = "${var.lambda_name}_sts",
      Principal = {
        Service = "lambda.amazonaws.com"
      },
    }],
  })
}

data "aws_iam_policy_document" "policy_document" {
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
    sid       = "AllowDynamoDBQuery"
    effect    = "Allow"
    resources = ["*"]
    actions = [
      "dynamodb:GetItem",
      "dynamodb:Query"
    ]
  }
}

resource "aws_iam_policy" "policy" {
  name   = "${var.lambda_name}-policy"
  policy = data.aws_iam_policy_document.policy_document.json
}

resource "aws_iam_role_policy_attachment" "policy_attach" {
  policy_arn = aws_iam_policy.policy.arn
  role       = aws_iam_role.role.name
}
