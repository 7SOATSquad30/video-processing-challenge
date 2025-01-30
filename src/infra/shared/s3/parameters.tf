# Store the S3 ID in the Parameter Store
resource "aws_ssm_parameter" "s3_bucket_id" {
  name  = "/s3/s3_bucket_id"
  type  = "String"
  value = aws_s3_bucket.video_processing_files.id
}

# Store the S3 ARN in the Parameter Store
resource "aws_ssm_parameter" "s3_bucket_arn" {
  name  = "/s3/s3_bucket_arn"
  type  = "String"
  value = aws_s3_bucket.video_processing_files.arn
}
