# S3 bucket ID
output "s3_bucket_id" {
  description = "S3 bucket ID"
  value       = aws_s3_bucket.videos_s3_bucket.id
}

# S3 bucket ARN
output "s3_bucket_arn" {
  description = "S3 bucket ARN"
  value       = aws_s3_bucket.videos_s3_bucket.arn
}
