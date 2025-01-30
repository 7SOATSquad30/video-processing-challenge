# Setting up e-mail identity in SES
resource "aws_ses_email_identity" "ses_email_identity" {
  email = var.ses_email_address
}

# Setting up domain identity in SES
resource "aws_ses_domain_identity" "ses_domain_identity" {
  domain = var.ses_domain_identity_name
}

# Setting up SMTP credentials for SES
resource "aws_iam_user" "ses_smtp_user" {
  name = var.ses_smtp_user_name
}

# Setting up SMTP user policy
resource "aws_iam_user_policy" "ses_smtp_policy" {
  name = var.ses_smtp_policy_name

  user = aws_iam_user.ses_smtp_user.name
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : "ses:SendRawEmail",
        "Resource" : "*"
      }
    ]
  })
}

# Setting up SMTP access key
resource "aws_iam_access_key" "ses_smtp_credentials" {
  user = aws_iam_user.ses_smtp_user.name
}
