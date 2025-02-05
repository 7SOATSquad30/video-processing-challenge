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

module "iam_lambda_video_processing" {
  source = "./iam"
  role_name = "lambda_video_processing_role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action = "sts:AssumeRole",
      Effect = "Allow",
      Sid    = "lambda_video_processing_role_sts",
      Principal = {
        Service = "lambda.amazonaws.com"
      },
    }],
  })
  policy_statements = [
    {
      Effect    = "Allow"
      Resource = ["*"]
      Action   = ["s3:GetObject", "s3:PutObject", "s3:PutBucketAcl"]
    },
    {
      Effect    = "Allow"
      Resource = ["*"]
      Action   = ["sqs:ReceiveMessage", "sqs:DeleteMessage", "sqs:GetQueueAttributes"]
    },
    {
      Effect    = "Allow"
      Resource = ["*"]
      Action = ["dynamodb:UpdateItem", "dynamodb:GetItem"]
    },
    {
      Effect = "Allow",
      Resource = ["*"]
      Action = ["ses:SendEmail"],
    },
  ]

  depends_on = [module.dynamodb, module.s3, module.ses, module.sns, module.sqs]
}

module "lambda_video_processing_ffmpeg_layer" {
  source = "./lambda_layer"
  layer_name = "ffmpeg-layer"
  layer_bucket_name = "ffmpeg-package-for-lambda"
  layer_bucket_key = "ffmpeg_layer"
  layer_compatible_runtimes = ["python3.9", "python3.10", "python3.11", "python3.12", "python3.13"]
  layer_zipfile_path = "../../lambda-video-processing/ffmpeg-layer.zip"

  depends_on = [module.s3]
}

module "lambda_video_processing" {
  source = "./lambda"
  lambda_name = "lambda_video_processing"
  lambda_source_dir = "../../lambda-video-processing"
  lambda_output_path = "../../lambda-video-processing/deployment_package.zip"
  lambda_runtime = "python3.13"
  lambda_handler = "app.lambda_function.lambda_handler"
  lambda_timeout = 900
  lambda_memsize = 512
  lambda_ephemeral_storage = 10240
  lambda_iam_role_to_assume_arn = module.iam_lambda_video_processing.lambda_iam_role_to_assume_arn
  lambda_layers = [
    module.lambda_video_processing_ffmpeg_layer.version_arn
  ]
  lambda_environment = {
    DYNAMODB_TABLE_NAME  = module.dynamodb.dynamodb_table_name
    S3_BUCKET            = module.s3.s3_bucket_name
    SES_SOURCE_EMAIL     = module.ses.ses_user_email
  }

  depends_on = [module.iam_lambda_video_processing, module.lambda_video_processing_ffmpeg_layer]
}