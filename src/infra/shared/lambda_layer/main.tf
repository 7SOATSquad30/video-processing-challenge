resource "aws_s3_object" "data" {
  bucket = var.layer_bucket_name
  key    = var.layer_bucket_key
  source = var.layer_zipfile_path
  etag   = filemd5(var.layer_zipfile_path)
}

resource "aws_lambda_layer_version" "version" {
  layer_name          = var.layer_name
  description         = "${var.layer_name} lambda layer"
  compatible_runtimes = var.layer_compatible_runtimes

  s3_bucket = var.layer_bucket_name
  s3_key    = var.layer_bucket_key

  depends_on = [aws_s3_object.data]
}