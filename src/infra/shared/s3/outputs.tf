output "s3_bucket_id" {
  description = "S3 bucket ID"
  value       = aws_s3_bucket.videos_s3_bucket.id
}

output "s3_bucket_arn" {
  description = "S3 bucket ARN"
  value       = aws_s3_bucket.videos_s3_bucket.arn
}

output "s3_bucket_name" {
  description = "S3 bucket name"
  value       = aws_s3_bucket.videos_s3_bucket.bucket
}
