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

variable "lambda_name" {
  description = "S3 use path style"
  default     = "lambda-status-video-processing"
}

variable "dynamodb_table_name" {
  description = "Nome da tabela DynamoDB"
  type        = string
  default     = "table_videos"
}
