/*
resource "aws_s3_bucket" "lambda" {
  bucket = local.component_name
}

resource "aws_s3_bucket_acl" "lambda" {
  bucket = local.component_name
  acl    = "private"
}
*/