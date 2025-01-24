output "s3_bucket_arn" {
  value = aws_s3_bucket.video_processing_files.arn
}

output "sqs_queue_url" {
  value = aws_sqs_queue.videos_to_process.id
}

output "lambda" {
  value = {
    arn        = aws_lambda_function.upload_lambda.arn
    name       = aws_lambda_function.upload_lambda.name
    invoke_arn = aws_lambda_function.upload_lambda.invoke_arn
  }
}