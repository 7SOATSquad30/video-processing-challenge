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

variable "sqs_queue_name" {
  default = "videos-to-process"
}
