# SQS queue name
variable "sqs_queue_name" {
  description = "SQS queue name"
  type        = string
}

# SQS Dead-letter queue name
variable "sqs_dlq_name" {
  description = "SQS Dead-letter queue name"
  type        = string
}
