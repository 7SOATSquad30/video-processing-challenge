resource "aws_iam_role" "role" {
  name = var.role_name
  assume_role_policy = var.assume_role_policy
}

locals {
  predefined_statements = [
    {
      Effect   = "Allow"
      Resource = ["arn:aws:logs:*:*"]
      Action   = ["logs:CreateLogGroup"]
    },
    {
      Effect   = "Allow"
      Resource = ["arn:aws:logs:*:*:log-group:/aws/lambda/*:*"]
      Action   = ["logs:CreateLogStream", "logs:PutLogEvents"]
    }
  ]
}

resource "aws_iam_policy" "policy" {
  name   = "${var.role_name}_policy"
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = concat(local.predefined_statements, var.policy_statements)
  })
}

resource "aws_iam_role_policy_attachment" "policy_attach" {
  policy_arn = aws_iam_policy.policy.arn
  role       = aws_iam_role.role.name
}
