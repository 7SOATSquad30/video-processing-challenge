# SNS topic ID
output "sns_topic_id" {
  description = "SNS topic ID"
  value       = aws_sns_topic.videos_processed_topic.id
}

# SNS topic ARN
output "sns_topic_arn" {
  description = "SNS topic ARN"
  value       = aws_sns_topic.videos_processed_topic.arn
}
