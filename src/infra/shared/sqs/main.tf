# Create a SQS queue
resource "aws_sqs_queue" "videos_to_process_queue" {
  name                    = var.sqs_queue_name
  sqs_managed_sse_enabled = true
}

# Create a SQS Dead-letter queue
resource "aws_sqs_queue" "videos_to_process_dlq" {
  name = var.sqs_dlq_name

  redrive_allow_policy = jsonencode({
    redrivePermission = "byQueue",
    sourceQueueArns   = [aws_sqs_queue.videos_to_process_queue.arn]
  })
}

# Provide a Redrive Policy of an SQS Queue resource
resource "aws_sqs_queue_redrive_policy" "videos_to_process_queue" {
  queue_url = aws_sqs_queue.videos_to_process_queue.id

  redrive_policy = jsonencode({
    deadLetterTargetArn = aws_sqs_queue.videos_to_process_dlq.arn
    maxReceiveCount     = 10
  })
}
