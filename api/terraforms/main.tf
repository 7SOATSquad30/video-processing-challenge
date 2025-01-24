provider "aws" {
    region = "us-west-2"
}

resource "aws_s3_bucket" "lambda" {
    bucket = "video-raw-files"
    acl    = "private"
}

resource "aws_lambda_function" "video_processor" {
    filename         = "lambda_function_payload.zip"
    function_name    = "video_processor"
    role             = aws_iam_role.lambda_exec.arn
    handler          = "index.handler"
    runtime          = "nodejs14.x"
    source_code_hash = filebase64sha256("lambda_function_payload.zip")
}

resource "aws_iam_role" "lambda_exec" {
    name = "lambda_exec_role"

    assume_role_policy = jsonencode({
        Version = "2012-10-17"
        Statement = [
            {
                Action = "sts:AssumeRole"
                Effect = "Allow"
                Principal = {
                    Service = "lambda.amazonaws.com"
                }
            }
        ]
    })
}

resource "aws_iam_role_policy_attachment" "lambda_policy" {
    role       = aws_iam_role.lambda_exec.name
    policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_s3_bucket_notification" "bucket_notification" {
    bucket = aws_s3_bucket.video_bucket.id

    lambda_function {
        lambda_function_arn = aws_lambda_function.video_processor.arn
        events              = ["s3:ObjectCreated:*"]
    }
}