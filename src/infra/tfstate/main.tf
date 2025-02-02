/*data "aws_s3_bucket" "existing" {
  bucket = var.tf_state_bucket_name
}*/

resource "aws_s3_bucket" "tfstate_bucket" {
  count  = 1
  bucket = var.tf_state_bucket_name
}

provider "aws" {
  region = var.aws_region
  s3_use_path_style = var.s3_use_path_style
}