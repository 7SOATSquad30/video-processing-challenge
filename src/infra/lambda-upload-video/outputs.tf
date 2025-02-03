/*output "bucket" {
  value = {
    arn  = aws_s3_bucket.upload_lambda.arn
    name = aws_s3_bucket.upload_lambda.id
  }
}

output "s3_bucket_arn" {
  value = aws_s3_bucket.upload_lambda.arn
}

output "sqs_queue_url" {
  value = aws_sqs_queue.video_processing_queue.id
}*/

output "lambda" {
  value = {
    arn        = aws_lambda_function.upload_lambda.arn
    name       = aws_lambda_function.upload_lambda.function_name
    invoke_arn = aws_lambda_function.upload_lambda.invoke_arn
  }
}