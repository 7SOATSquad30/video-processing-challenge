# Create a DynamoDB table
resource "aws_dynamodb_table" "video_processing_files" {
  name         = var.dynamodb_table_name
  hash_key     = var.dynamodb_partition_key
  billing_mode = "PAY_PER_REQUEST"

  attribute {
    name = var.dynamodb_partition_key
    type = "S"
  }

  attribute {
    name = "status"
    type = "S"
  }
}
