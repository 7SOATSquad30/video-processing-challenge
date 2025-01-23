# Region
variable "aws_region" {
  description = "AWS region to create resources"
  type        = string
  default     = "us-east-1"
}

variable "aws_access_key" {
  default = "test"
}

variable "aws_secret_key" {
  default = "test"
}

# S3 bucket name
variable "s3_bucket_name" {
  description = "S3 bucket name"
  default     = "video-processing-files"
}

# DynamodB table name
variable "dynamodb_table_name" {
  description = "DynamodB table name"
  default     = "video-processing-files"
}

# DynamodB partition key
variable "dynamodb_partition_key" {
  description = "DynamodB partition key"
  default     = "video_id"
}

# SQS queue name
variable "sqs_queue_name" {
  description = "SQS queue name"
  default     = "videos-to-process"
}

# SQS Dead-letter queue name
variable "sqs_dlq_name" {
  description = "SQS Dead-letter queue name"
  default     = "videos-to-process-dlq"
}

# SNS topic name
variable "sns_topic_name" {
  description = "SNS topic name"
  default     = "videos-processed-topic"
}

# Email address
variable "ses_email_address" {
  description = "The email address to use for SES verification"
}

# SES domain identity name
variable "ses_domain_identity_name" {
  description = "SES domain identity name"
}

# SES identity policy
variable "ses_identity_policy_name" {
  description = "SES identity policy"
  default     = "video-processing-identity-policy"
}

# SMTP credentials for SES
variable "ses_smtp_user_name" {
  description = "SMTP credentials for SES"
  default     = "video-processing-smtp-user"
}

# SMTP user policy
variable "ses_smtp_policy_name" {
  description = "SMTP user policy"
  default     = "video-processing-smtp-policy"
}
