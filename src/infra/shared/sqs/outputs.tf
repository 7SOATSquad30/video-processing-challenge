# SQS queue ID
output "sqs_queue_id" {
  description = "SQS queue ID"
  value       = aws_sqs_queue.videos_to_process_queue.id
}

# SQS queue ARN
output "sqs_queue_arn" {
  description = "SQS queue ARN"
  value       = aws_sqs_queue.videos_to_process_queue.arn
}

# SQS Dead-letter queue ID
output "sqs_dlq_id" {
  description = "SQS Dead-letter queue ID"
  value       = aws_sqs_queue.videos_to_process_dlq.id
}

# SQS Dead-letter queue ARN
output "sqs_dlq_arn" {
  description = "SQS Dead-letter queue ARN"
  value       = aws_sqs_queue.videos_to_process_dlq.arn
}
