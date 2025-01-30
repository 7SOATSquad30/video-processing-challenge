variable "aws_region" {
  description = "AWS region where resources will be created"
  type        = string
  default     = "us-east-1"
}

variable "dynamodb_table_name" {
  description = "Nome da tabela DynamoDB"
  type        = string
  default     = "table_videos"
}

variable "output_s3_bucket" {
  description = "Nome do bucket S3 para saída"
  type        = string
  default     = "teste-arquivos-videos"
}

variable "sqs_queue_name" {
  type        = string
  default     = "sqs-processamento-video"
}

variable "bucket_name_ffmpeg" {
  description = "Nome do bucket S3 onde o FFmpeg está armazenado"
  type        = string
  default     = "ffmpeg-package-for-lambda"
}

variable "s3_use_path_style" {
  type = bool
  default = false
}