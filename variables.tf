variable "aws_region" {
  default = "us-east-1"
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
