resource "aws_s3_bucket" "tfstate_bucket" {
  bucket = var.tf_state_bucket_name
}

provider "aws" {
  region = var.aws_region
  s3_use_path_style = var.s3_use_path_style
}