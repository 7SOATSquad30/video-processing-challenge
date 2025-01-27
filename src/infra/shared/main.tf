resource "aws_s3_bucket" "ffmpeg_layer" {
  bucket = var.bucket_name_ffmpeg
}

terraform {
  backend "s3" {
    bucket         = "fiap-challenge-terraform-state"
    key            = "video-processing-challenge/shared.tfstate"
    region         = "us-east-1"
    encrypt        = true
  }
}

provider "aws" {
  region = var.aws_region
  s3_use_path_style = var.s3_use_path_style
}