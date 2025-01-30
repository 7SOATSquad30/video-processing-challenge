terraform {
  backend "s3" {
    bucket  = "fiap-challenge-terraform-state"
    key     = "video-processing-challenge/shared.tfstate"
    region  = "us-east-1"
    encrypt = true
  }
}

provider "aws" {
  region            = var.aws_region
  s3_use_path_style = var.s3_use_path_style
}

# Connect the S3 module
module "s3" {
  source             = "./modules/s3"
  output_s3_bucket   = var.output_s3_bucket
  bucket_name_ffmpeg = var.bucket_name_ffmpeg
}

resource "aws_dynamodb_table" "videos_dynamo_table" {
  name         = var.dynamodb_table_name
  hash_key     = "object_key"
  billing_mode = "PAY_PER_REQUEST"

  attribute {
    name = "object_key"
    type = "S"
  }
}

resource "aws_sqs_queue" "video_processing_queue" {
  name                        = var.sqs_queue_name
  delay_seconds               = 0
  max_message_size            = 262144
  message_retention_seconds   = 345600
  visibility_timeout_seconds  = 900
  fifo_queue                  = false
  content_based_deduplication = false
}
