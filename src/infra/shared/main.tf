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
  output_s3_bucket   = "output-arquivos-videos"
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

module "api_gateway" {
  source   = "./api_gateway/api"
  api_name = "video-upload-api"
}

module "iam_lambda_video_processing" {
  source    = "./iam"
  role_name = "LambdaVideoProcessingRole"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action = "sts:AssumeRole",
      Effect = "Allow",
      Sid    = "LambdaVideoProcessingRoleSts",
      Principal = {
        Service = "lambda.amazonaws.com"
      },
    }],
  })
  policy_statements = [
    {
      Effect   = "Allow"
      Resource = ["*"]
      Action   = ["s3:GetObject", "s3:PutObject", "s3:PutBucketAcl"]
    },
    {
      Effect   = "Allow"
      Resource = ["*"]
      Action   = ["sqs:ReceiveMessage", "sqs:DeleteMessage", "sqs:GetQueueAttributes"]
    },
    {
      Effect   = "Allow"
      Resource = ["*"]
      Action   = ["dynamodb:UpdateItem", "dynamodb:GetItem"]
    },
    {
      Effect   = "Allow",
      Resource = ["*"]
      Action   = ["ses:SendEmail"],
    },
  ]

  depends_on = [module.dynamodb, module.s3, module.ses, module.sns, module.sqs]
}

module "lambda_video_processing_ffmpeg_layer" {
  source                    = "./lambda_layer"
  layer_name                = "ffmpeg-layer"
  layer_bucket_name         = "ffmpeg-package-for-lambda"
  layer_bucket_key          = "ffmpeg_layer"
  layer_compatible_runtimes = ["python3.9", "python3.10", "python3.11", "python3.12", "python3.13"]
  layer_zipfile_path        = "../../lambda-video-processing/ffmpeg-layer.zip"

  depends_on = [module.s3]
}

module "lambda_video_processing" {
  source                        = "./lambda"
  lambda_name                   = "lambda_video_processing"
  lambda_output_path            = "../../lambda-video-processing/deployment_package.zip"
  lambda_runtime                = "python3.13"
  lambda_handler                = "app.lambda_function.lambda_handler"
  lambda_timeout                = 900
  lambda_memsize                = 512
  lambda_ephemeral_storage      = 10240
  lambda_iam_role_to_assume_arn = module.iam_lambda_video_processing.lambda_iam_role_to_assume_arn
  lambda_layers = [
    module.lambda_video_processing_ffmpeg_layer.version_arn
  ]
  lambda_environment = {
    DYNAMODB_TABLE_NAME = module.dynamodb.dynamodb_table_name
    S3_BUCKET           = module.s3.s3_bucket_name
    SES_SOURCE_EMAIL    = module.ses.ses_user_email
    ENVIRONMENT         = var.environment
  }

  depends_on = [module.iam_lambda_video_processing, module.lambda_video_processing_ffmpeg_layer]
}

module "iam_lambda_upload_video" {
  source    = "./iam"
  role_name = "LambdaUploadVideoRole"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action = "sts:AssumeRole",
      Effect = "Allow",
      Sid    = "LambdaUploadVideoRoleSts",
      Principal = {
        Service = "lambda.amazonaws.com"
      },
    }],
  })
  policy_statements = [
    {
      Effect   = "Allow"
      Resource = ["*"]
      Action   = ["s3:GetObject", "s3:PutObject", "s3:PutBucketAcl"]
    },
    {
      Effect   = "Allow"
      Resource = ["*"]
      Action   = ["sqs:SendMessage"]
    },
    {
      Effect   = "Allow"
      Resource = ["*"]
      Action   = ["dynamodb:InsertItem"]
    },
  ]

  depends_on = [module.dynamodb, module.s3, module.ses, module.sns, module.sqs]
}

module "lambda_upload_video" {
  source                        = "./lambda"
  lambda_name                   = "lambda_upload_video"
  lambda_output_path            = "../../lambda-upload-video/build.zip"
  lambda_runtime                = "nodejs20.x"
  lambda_handler                = "dist/index.handler"
  lambda_timeout                = 900
  lambda_memsize                = 512
  lambda_ephemeral_storage      = 10240
  lambda_iam_role_to_assume_arn = module.iam_lambda_upload_video.lambda_iam_role_to_assume_arn
  lambda_environment = {
    DYNAMODB_TABLE_NAME = module.dynamodb.dynamodb_table_name
    SQS_QUEUE_URL       = module.sqs.sqs_queue_url
    INPUT_S3_BUCKET     = module.s3.s3_bucket_name
    ENVIRONMENT         = var.environment
  }

  depends_on = [module.iam_lambda_upload_video]
}

module "lambda_upload_video_api_routes" {
  source               = "./api_gateway/routes"
  api_id               = module.api_gateway.api_id
  api_root_resource_id = module.api_gateway.api_root_resource_id
  routes = [{
    path_parts              = ["users", "{userId}", "videos"]
    http_method             = "POST"
    integration_type        = "AWS_PROXY"
    integration_http_method = "POST"
    integration_uri         = module.lambda_upload_video.lambda_invoke_arn
    passthrough_behavior    = "WHEN_NO_MATCH"
    content_handling        = "CONVERT_TO_TEXT"
  }]

  depends_on = [module.api_gateway, module.lambda_upload_video]
}
resource "aws_lambda_permission" "lambda_upload_video_api_routes_permission" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = module.lambda_upload_video.lambda_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${module.api_gateway.api_execution_arn}/*/*"

  depends_on = [module.api_gateway, module.lambda_upload_video]
}

module "iam_lambda_status_video_processing" {
  source    = "./iam"
  role_name = "LambdaStatusVideoProcessingRole"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action = "sts:AssumeRole",
      Effect = "Allow",
      Sid    = "LambdaStatusVideoProcessingRoleSts",
      Principal = {
        Service = "lambda.amazonaws.com"
      },
    }],
  })
  policy_statements = [
    {
      Effect   = "Allow"
      Resource = ["*"]
      Action   = ["dynamodb:GetItem", "dynamodb:Query"]
    },
  ]

  depends_on = [module.dynamodb]
}

module "lambda_status_video_processing" {
  source                        = "./lambda"
  lambda_name                   = "lambda_status_video_processing"
  lambda_output_path            = "../../lambda-status-video-processing/build.zip"
  lambda_runtime                = "nodejs20.x"
  lambda_handler                = "dist/index.handler"
  lambda_timeout                = 900
  lambda_memsize                = 512
  lambda_ephemeral_storage      = 10240
  lambda_iam_role_to_assume_arn = module.iam_lambda_status_video_processing.lambda_iam_role_to_assume_arn
  lambda_environment = {
    DYNAMODB_TABLE_NAME = module.dynamodb.dynamodb_table_name
    ENVIRONMENT         = var.environment
  }

  depends_on = [module.iam_lambda_status_video_processing]
}

module "lambda_status_video_processing_api_routes" {
  source               = "./api_gateway/routes"
  api_id               = module.api_gateway.api_id
  api_root_resource_id = module.api_gateway.api_root_resource_id
  routes = [{
    path_parts              = ["users", "{userId}", "videos"]
    http_method             = "GET"
    integration_type        = "AWS_PROXY"
    integration_http_method = "POST"
    integration_uri         = module.lambda_status_video_processing.lambda_invoke_arn
    passthrough_behavior    = "WHEN_NO_MATCH"
    content_handling        = "CONVERT_TO_TEXT"
  }]

  depends_on = [module.api_gateway, module.lambda_status_video_processing]
}
resource "aws_lambda_permission" "lambda_status_video_processing_api_routes_permission" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = module.lambda_status_video_processing.lambda_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${module.api_gateway.api_execution_arn}/*/*"

  depends_on = [module.api_gateway, module.lambda_status_video_processing]
}

module "api_gateway_deployment" {
  source = "./api_gateway/deployment"
  api_id = module.api_gateway.api_id

  depends_on = [module.lambda_upload_video_api_routes, module.lambda_status_video_processing_api_routes]
}
