resource "aws_iam_role_policy_attachment" "lambda_policy" {
  role       = aws_iam_role.upload_lambda.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

// Remover qualquer configuração de ACL para o bucket S3
// resource "aws_s3_bucket_acl" "lambda" {
//   bucket = aws_s3_bucket.lambda.id
//   acl    = "private"
// }

resource "aws_sqs_queue" "videos_to_process" {
  name = var.sqs_queue_name
}

data "aws_caller_identity" "current" {}
