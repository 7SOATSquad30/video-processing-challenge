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
  source             = "./s3"
  output_s3_bucket   = var.output_s3_bucket
  bucket_name_ffmpeg = var.bucket_name_ffmpeg
}

# Connect the DynamoDB module
module "dynamodb" {
  source                 = "./dynamodb"
  dynamodb_table_name    = var.dynamodb_table_name
  dynamodb_partition_key = var.dynamodb_partition_key
}

# Connect the SQS module
module "sqs" {
  source         = "./sqs"
  sqs_queue_name = var.sqs_queue_name
  sqs_dlq_name   = var.sqs_dlq_name
}
