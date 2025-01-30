provider "aws" {
  region = var.aws_region
}

# Connect the S3 module
module "s3" {
  source         = "./modules/s3"
  s3_bucket_name = var.s3_bucket_name
}

# Connect the DynamoDB module
module "dynamodb" {
  source                 = "./modules/dynamodb"
  dynamodb_table_name    = var.dynamodb_table_name
  dynamodb_partition_key = var.dynamodb_partition_key
}

# Connect the SQS module
module "sqs" {
  source         = "./modules/sqs"
  sqs_queue_name = var.sqs_queue_name
  sqs_dlq_name   = var.sqs_dlq_name
}

# Connect the SNS module
module "sns" {
  source         = "./modules/sns"
  sns_topic_name = var.sns_topic_name
}

# Connect the SES module
module "ses" {
  source                   = "./modules/ses"
  ses_email_address        = var.ses_email_address
  ses_domain_identity_name = var.ses_domain_identity_name
  ses_identity_policy_name = var.ses_identity_policy_name
  ses_smtp_user_name       = var.ses_smtp_user_name
  ses_smtp_policy_name     = var.ses_smtp_policy_name
}
