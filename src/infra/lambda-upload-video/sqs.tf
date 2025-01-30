/*
data "aws_sqs_queue" "video_processing_queue" {
  name = var.sqs_queue_name
}

resource "aws_lambda_event_source_mapping" "sqs_event_source" {
  event_source_arn = data.aws_sqs_queue.video_processing_queue.arn
  function_name    = aws_lambda_function.upload_lambda.arn
  batch_size       = 5
}
*/