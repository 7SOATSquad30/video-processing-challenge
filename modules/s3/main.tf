# Create a S3 bucket
resource "aws_s3_bucket" "video_processing_files" {
  bucket = var.s3_bucket_name
}
