variable "aws_region" {
  description = "AWS region where resources will be created"
  type        = string
  default     = "us-east-1"
}

variable "s3_bucket_name" {
  default = "video-processing-files"
}

variable "input_s3_bucket" {
  description = "Nome do bucket S3 para entrada"
  type        = string
  default     = "input"
}

variable "sqs_queue_name" {
  type    = string
  default = "sqs-processamento-video"
}

variable "dynamodb_table_name" {
  description = "Nome da tabela DynamoDB"
  type        = string
  default     = "table_videos"
}
