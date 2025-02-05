variable "lambda_name" {
  type = string
}

variable "lambda_iam_role_to_assume_arn" {
  type = string
}

variable "dynamodb_table_name" {
  type = string
}

variable "input_s3_bucket" {
  type = string
}
