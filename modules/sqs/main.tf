# Create a SQS queue
resource "aws_sqs_queue" "videos_to_process_queue" {
  name                    = var.sqs_queue_name
  sqs_managed_sse_enabled = true

  redrive_policy = jsonencode({
    deadLetterTargetArn = aws_sqs_queue.videos_to_process_dlq.arn
    maxReceiveCount     = 10
  })
}

# Create a SQS Dead-letter queue
resource "aws_sqs_queue" "videos_to_process_dlq" {
  name = var.sqs_dlq_name
}

# Provide a SQS Queue Redrive Allow Policy resource
resource "aws_sqs_queue_redrive_allow_policy" "videos_to_process_queue_redrive_allow_policy" {
  queue_url = aws_sqs_queue.videos_to_process_dlq.id

  redrive_allow_policy = jsonencode({
    redrivePermission = "byQueue",
    sourceQueueArns   = [aws_sqs_queue.videos_to_process_queue.arn]
  })
}
