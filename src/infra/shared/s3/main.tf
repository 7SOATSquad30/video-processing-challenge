resource "aws_s3_bucket" "ffmpeg_layer" {
  bucket = var.bucket_name_ffmpeg
}

resource "aws_s3_bucket" "videos_s3_bucket" {
  bucket = var.output_s3_bucket
}
