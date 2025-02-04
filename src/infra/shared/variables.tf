variable "aws_region" {
  description = "AWS region where resources will be created"
  type        = string
  default     = "us-east-1"
}

variable "output_s3_bucket" {
  description = "Nome do bucket S3 para saída"
  type        = string
  default     = "teste-arquivos-videos"
}

variable "bucket_name_ffmpeg" {
  description = "Nome do bucket S3 onde o FFmpeg está armazenado"
  type        = string
  default     = "ffmpeg-package-for-lambda"
}

variable "s3_use_path_style" {
  description = "S3 use path style"
  type        = bool
  default     = false
}

variable "dynamodb_table_name" {
  description = "DynamodB table name"
  default     = "table_videos"
}

variable "dynamodb_partition_key" {
  description = "DynamodB partition key"
  default     = "object_key"
}

variable "sqs_queue_name" {
  description = "SQS queue name"
  default     = "sqs-processamento-video"
}

variable "sqs_dlq_name" {
  description = "SQS Dead-letter queue name"
  default     = "videos-to-process-dlq"
}

variable "sns_topic_name" {
  description = "SNS topic name"
  default     = "videos-processed-topic"
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
