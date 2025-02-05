# Create a DynamoDB table
resource "aws_dynamodb_table" "videos_dynamo_table" {
  name         = var.dynamodb_table_name
  hash_key     = var.dynamodb_partition_key
  range_key    = var.dynamodb_range_key
  billing_mode = "PAY_PER_REQUEST"

  attribute {
    name = var.dynamodb_partition_key
    type = "S"
  }

  attribute {
    name = var.dynamodb_range_key
    type = "S"
  }
}
