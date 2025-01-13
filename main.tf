provider "aws" {
  region  = var.aws_region
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
}

resource "aws_s3_bucket" "video_processing_files" {
  bucket = var.s3_bucket_name
}

resource "aws_sqs_queue" "videos_to_process" {
  name = var.sqs_queue_name
}