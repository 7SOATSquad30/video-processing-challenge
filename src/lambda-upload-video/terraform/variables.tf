variable "aws_region" {
  default = "us-east-1"
}

variable "aws_access_key" {
  default = "test"
}

variable "aws_secret_key" {
  default = "test"
}

variable "s3_bucket_name" {
  default = "video-processing-files"
}

variable "sqs_queue_name" {
  default = "video_processing_queue"
}
