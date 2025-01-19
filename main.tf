provider "aws" {
  region     = var.aws_region
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
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

resource "aws_sqs_queue" "videos_to_process" {
  name = var.sqs_queue_name
}
