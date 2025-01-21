# Create a SNS topic
resource "aws_sns_topic" "videos_processed_topic" {
  name = var.sns_topic_name
}
