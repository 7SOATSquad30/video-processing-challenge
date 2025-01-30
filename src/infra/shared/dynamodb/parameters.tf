# Store the DynamoDB table ID in the Parameter Store
resource "aws_ssm_parameter" "dynamodb_table_id" {
  name  = "/dynamodb/dynamodb_table_id"
  type  = "String"
  value = aws_dynamodb_table.video_processing_files.id
}

# Store the DynamoDB table ARN in the Parameter Store
resource "aws_ssm_parameter" "dynamodb_table_arn" {
  name  = "/dynamodb/dynamodb_table_arn"
  type  = "String"
  value = aws_dynamodb_table.video_processing_files.arn
}
