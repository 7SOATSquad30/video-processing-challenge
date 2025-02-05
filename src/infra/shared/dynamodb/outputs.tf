output "dynamodb_table_id" {
  description = "DynamoDB table ID"
  value       = aws_dynamodb_table.videos_dynamo_table.id
}

output "dynamodb_table_arn" {
  description = "DynamoDB table ARN"
  value       = aws_dynamodb_table.videos_dynamo_table.arn
}

output "dynamodb_table_name" {
  description = "DynamoDB table name"
  value       = aws_dynamodb_table.videos_dynamo_table.name
}
