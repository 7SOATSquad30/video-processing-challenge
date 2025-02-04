# DynamoDB table ID
output "dynamodb_table_id" {
  description = "DynamoDB table ID"
  value       = aws_dynamodb_table.videos_dynamo_table.id
}

# DynamoDB table ARN
output "dynamodb_table_arn" {
  description = "DynamoDB table ARN"
  value       = aws_dynamodb_table.videos_dynamo_table.arn
}
