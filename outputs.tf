output "s3_bucket_arn" {
  value = aws_s3_bucket.video_processing_files.arn
}

output "sqs_queue_url" {
  value = aws_sqs_queue.videos_to_process.id
}