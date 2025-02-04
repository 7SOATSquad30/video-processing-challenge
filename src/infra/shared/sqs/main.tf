# Create a SQS queue
resource "aws_sqs_queue" "video_processing_queue" {
  name                        = var.sqs_queue_name
  delay_seconds               = 0
  max_message_size            = 262144
  message_retention_seconds   = 345600
  visibility_timeout_seconds  = 900
  fifo_queue                  = false
  content_based_deduplication = false
  sqs_managed_sse_enabled     = true
}

# Create a SQS Dead-letter queue
resource "aws_sqs_queue" "video_processing_dlq" {
  name = var.sqs_dlq_name

  redrive_allow_policy = jsonencode({
    redrivePermission = "byQueue",
    sourceQueueArns   = [aws_sqs_queue.video_processing_queue.arn]
  })
}

# Provide a Redrive Policy of an SQS Queue resource
resource "aws_sqs_queue_redrive_policy" "video_processing_queue" {
  queue_url = aws_sqs_queue.video_processing_queue.id

  redrive_policy = jsonencode({
    deadLetterTargetArn = aws_sqs_queue.video_processing_dlq.arn
    maxReceiveCount     = 10
  })
}
