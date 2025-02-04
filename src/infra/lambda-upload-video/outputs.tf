/*output "bucket" {
  value = {
    arn  = aws_s3_bucket.lambda_upload.arn
    name = aws_s3_bucket.lambda_upload.id
  }
}

output "s3_bucket_arn" {
  value = aws_s3_bucket.lambda_upload.arn
}

output "sqs_queue_url" {
  value = aws_sqs_queue.video_processing_queue.id
}*/

output "lambda" {
  value = {
    arn        = aws_lambda_function.lambda_upload.arn
    name       = aws_lambda_function.lambda_upload.function_name
    invoke_arn = aws_lambda_function.lambda_upload.invoke_arn
  }
}