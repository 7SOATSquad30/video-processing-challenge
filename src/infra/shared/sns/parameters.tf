# Store the SNS topic ID in the Parameter Store
resource "aws_ssm_parameter" "sns_topic_id" {
  name  = "/sns/sns_topic_id"
  type  = "String"
  value = aws_sns_topic.videos_processed_topic.id
}

# Store the SNS topic ARN in the Parameter Store
resource "aws_ssm_parameter" "sns_topic_arn" {
  name  = "/sns/sns_topic_arn"
  type  = "String"
  value = aws_sns_topic.videos_processed_topic.arn
}
