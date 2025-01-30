# Store the SQS queue ID in the Parameter Store
resource "aws_ssm_parameter" "sqs_queue_id" {
  name  = "/sqs/sqs_queue_id"
  type  = "String"
  value = aws_sqs_queue.video_processing_queue.id
}

# Store the SQS queue ARN in the Parameter Store
resource "aws_ssm_parameter" "sqs_queue_arn" {
  name  = "/sqs/sqs_queue_arn"
  type  = "String"
  value = aws_sqs_queue.video_processing_queue.arn
}

# Store the SQS Dead-letter queue ID in the Parameter Store
resource "aws_ssm_parameter" "sqs_dlq_id" {
  name  = "/sqs/sqs_dlq_id"
  type  = "String"
  value = aws_sqs_queue.video_processing_dlq.id
}

# Store the SQS Dead-letter queue ARN in the Parameter Store
resource "aws_ssm_parameter" "sqs_dlq_arn" {
  name  = "/sqs/sqs_dlq_arn"
  type  = "String"
  value = aws_sqs_queue.video_processing_dlq.arn
}
