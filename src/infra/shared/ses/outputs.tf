# SES email identity ID
output "ses_email_identity_id" {
  description = "SES email identity ID"
  value       = aws_ses_email_identity.ses_email_identity.id
}

# SES email identity ARN
output "ses_email_identity_arn" {
  description = "SES email identity ARN"
  value       = aws_ses_email_identity.ses_email_identity.arn
}

# SES domain identity ID
output "ses_domain_identity_id" {
  description = "SES domain identity ID"
  value       = aws_ses_domain_identity.ses_domain_identity.id
}

# SES domain identity ARN
output "ses_domain_identity_arn" {
  description = "SES domain identity ARN"
  value       = aws_ses_domain_identity.ses_domain_identity.arn
}
