
resource "aws_dynamodb_table" "videos_dynamo_table" {
  name         = var.dynamodb_table_name
  hash_key     = "object_key"
  billing_mode = "PAY_PER_REQUEST"

  attribute {
    name = "object_key"
    type = "S"
  }
}
