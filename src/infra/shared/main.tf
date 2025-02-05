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

module "s3" {
  source             = "./s3"
  output_s3_bucket   = "teste-arquivos-videos"
  bucket_name_ffmpeg = "ffmpeg-package-for-lambda"
}

module "dynamodb" {
  source                 = "./dynamodb"
  dynamodb_table_name    = "table_videos"
  dynamodb_partition_key = "user_id"
  dynamodb_range_key     = "video_id"
}

module "sqs" {
  source         = "./sqs"
  sqs_queue_name = "sqs-processamento-video"
  sqs_dlq_name   = "videos-to-process-dlq"
}

module "sns" {
  source         = "./sns"
  sns_topic_name = "videos-processed-topic"
}

module "ses" {
  source                   = "./ses"
  ses_email_address        = var.ses_email_address
  ses_domain_identity_name = var.ses_domain_identity_name
  ses_identity_policy_name = var.ses_identity_policy_name
  ses_smtp_user_name       = var.ses_smtp_user_name
  ses_smtp_policy_name     = var.ses_smtp_policy_name
}
