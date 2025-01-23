# Email address
variable "ses_email_address" {
  description = "The email address to use for SES verification"
  type        = string
}

# SES domain identity name
variable "ses_domain_identity_name" {
  description = "SES domain identity name"
  type        = string
}

# SES identity policy
variable "ses_identity_policy_name" {
  description = "SES identity policy"
  type        = string
}

# SMTP credentials for SES
variable "ses_smtp_user_name" {
  description = "SMTP credentials for SES"
  type        = string
}

# SMTP user policy
variable "ses_smtp_policy_name" {
  description = "SMTP user policy"
  type        = string
}

