output "ses_email_identity_id" {
  description = "SES email identity ID"
  value       = aws_ses_email_identity.ses_email_identity.id
}

output "ses_email_identity_arn" {
  description = "SES email identity ARN"
  value       = aws_ses_email_identity.ses_email_identity.arn
}

output "ses_domain_identity_id" {
  description = "SES domain identity ID"
  value       = aws_ses_domain_identity.ses_domain_identity.id
}

output "ses_domain_identity_arn" {
  description = "SES domain identity ARN"
  value       = aws_ses_domain_identity.ses_domain_identity.arn
}

output "ses_user_email" {
  description = "SES user email"
  value       = aws_ses_email_identity.ses_email_identity.email
}
