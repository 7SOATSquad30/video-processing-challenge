# S3 bucket ID
output "s3_bucket_id" {
  description = "S3 bucket ID"
  value       = module.s3.s3_bucket_id
}

# S3 bucket ARN
output "s3_bucket_arn" {
  description = "S3 bucket ARN"
  value       = module.s3.s3_bucket_arn
}

# DynamoDB table ID
output "dynamodb_table_id" {
  description = "DynamoDB table ID"
  value       = module.dynamodb.dynamodb_table_id
}

# DynamoDB table ARN
output "dynamodb_table_arn" {
  description = "DynamoDB table ARN"
  value       = module.dynamodb.dynamodb_table_arn
}

# SQS queue ID
output "sqs_queue_id" {
  description = "SQS queue ID"
  value       = module.sqs.sqs_queue_id
}

# SQS queue ARN
output "sqs_queue_arn" {
  description = "SQS queue ARN"
  value       = module.sqs.sqs_queue_arn
}

# SQS Dead-letter queue ID
output "sqs_dlq_id" {
  description = "SQS Dead-letter queue ID"
  value       = module.sqs.sqs_dlq_id
}

# SQS Dead-letter queue ARN
output "sqs_dlq_arn" {
  description = "SQS Dead-letter queue ARN"
  value       = module.sqs.sqs_dlq_arn
}

# SNS topic ID
output "sns_topic_id" {
  description = "SNS topic ID"
  value       = module.sns.sns_topic_id
}

# SNS topic ARN
output "sns_topic_arn" {
  description = "SNS topic ARN"
  value       = module.sns.sns_topic_arn
}

# SES email identity ID
output "ses_email_identity_id" {
  description = "SES email identity ID"
  value       = module.ses.ses_email_identity_id
}

# SES email identity ARN
output "ses_email_identity_arn" {
  description = "SES email identity ARN"
  value       = module.ses.ses_email_identity_arn
}

# SES domain identity ID
output "ses_identity_id" {
  description = "SES domain identity ID"
  value       = module.ses.ses_domain_identity_id
}

# SES domain identity ARN
output "ses_identity_arn" {
  description = "SES domain identity ARN"
  value       = module.ses.ses_domain_identity_arn
}
