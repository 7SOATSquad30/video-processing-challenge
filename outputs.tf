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

output "sqs_queue_url" {
  value = aws_sqs_queue.videos_to_process.id
}
