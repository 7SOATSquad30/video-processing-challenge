# DynamodB table name
variable "dynamodb_table_name" {
  description = "DynamodB table name"
  type        = string
}

# DynamodB partition key
variable "dynamodb_partition_key" {
  description = "DynamodB partition key"
  type        = string
}

variable "dynamodb_range_key" {
  description = "DynamodB range key"
  type        = string
}
