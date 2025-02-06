variable "aws_region" {
  description = "AWS region where resources will be created"
  type        = string
  default     = "us-east-1"
}

variable "s3_use_path_style" {
  description = "S3 use path style"
  type        = bool
  default     = false
}

variable "ses_email_address" {
  description = "The email address to use for SES verification"
}

variable "ses_domain_identity_name" {
  description = "SES domain identity name"
}

variable "ses_identity_policy_name" {
  description = "SES identity policy"
  default     = "video-processing-identity-policy"
}

variable "ses_smtp_user_name" {
  description = "SMTP credentials for SES"
  default     = "video-processing-smtp-user"
}

variable "ses_smtp_policy_name" {
  description = "SMTP user policy"
  default     = "video-processing-smtp-policy"
}

variable "environment" {
  description = "production or development"
}