# Store the DynamoDB table ID in the Parameter Store
resource "aws_ssm_parameter" "dynamodb_table_id" {
  name  = "/dynamodb/dynamodb_table_id"
  type  = "String"
  value = aws_dynamodb_table.videos_dynamo_table.id
}

# Store the DynamoDB table ARN in the Parameter Store
resource "aws_ssm_parameter" "dynamodb_table_arn" {
  name  = "/dynamodb/dynamodb_table_arn"
  type  = "String"
  value = aws_dynamodb_table.videos_dynamo_table.arn
}
