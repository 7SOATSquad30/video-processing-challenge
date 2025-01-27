variable "aws_region" {
  description = "AWS region where resources will be created"
  type        = string
  default     = "us-east-1"
}

variable "lambda_function_name" {
  description = "Nome da função Lambda"
  type        = string
  default     = "LambdaProcessadorVideos"
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

variable "sqs_queue_arn" {
  description = "ARN da fila SQS para acionar a Lambda"
  type        = string
  default     = "arn:aws:sqs:us-east-1:691714441051:sqs-processamento-video"
}

variable "ses_source_email" {
  description = "Email de origem para notificação"
  type        = string
  default     = "otavio.sto@gmail.com"
}

variable "bucket_name_ffmpeg" {
  description = "Nome do bucket S3 onde o FFmpeg está armazenado"
  type        = string
  default     = "ffmpeg-package-for-lambda"
}

variable "object_key_ffmpeg" {
  description = "Caminho do arquivo FFmpeg no S3"
  type        = string
  default     = "ffmpeg/ffmpeg-release-amd64-static.zip"
}

variable "download_path_ffmpeg" {
  description = "Caminho local para download do arquivo FFmpeg"
  type        = string
  default     = "/tmp/ffmpeg-release-amd64-static.tar.xz"
}

variable "s3_use_path_style" {
  type = bool
  default = false
}