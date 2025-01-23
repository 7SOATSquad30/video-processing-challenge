# Store the SES email identity ID in the Parameter Store
resource "aws_ssm_parameter" "ses_identity_id" {
  name  = "/ses/ses_email_identity_id"
  type  = "String"
  value = aws_ses_email_identity.ses_email_identity.id
}

# Store the SES email identity ARN in the Parameter Store
resource "aws_ssm_parameter" "ses_identity_arn" {
  name  = "/ses/ses_email_identity_arn"
  type  = "String"
  value = aws_ses_email_identity.ses_email_identity.arn
}

# Store the SES domain identity ID in the Parameter Store
resource "aws_ssm_parameter" "ses_identity_id" {
  name  = "/ses/ses_domain_identity_id"
  type  = "String"
  value = aws_ses_domain_identity.ses_domain_identity.id
}

# Store the SES domain identity ARN in the Parameter Store
resource "aws_ssm_parameter" "ses_identity_arn" {
  name  = "/ses/ses_domain_identity_arn"
  type  = "String"
  value = aws_ses_domain_identity.ses_domain_identity.arn
}
