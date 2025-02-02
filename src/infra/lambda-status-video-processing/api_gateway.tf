resource "aws_api_gateway_rest_api" "api" {
  name        = "User Videos API"
  description = "API to fetch user videos"
}

resource "aws_api_gateway_resource" "user_videos_resource" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  parent_id   = aws_api_gateway_rest_api.api.root_resource_id
  path_part   = "users"
  depends_on  = [aws_api_gateway_rest_api.api]
}

resource "aws_api_gateway_resource" "user_videos_user_resource" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  parent_id   = aws_api_gateway_resource.user_videos_resource.id
  path_part   = "{userId}"
  depends_on  = [aws_api_gateway_resource.user_videos_resource]
}

resource "aws_api_gateway_resource" "user_videos_user_videos_resource" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  parent_id   = aws_api_gateway_resource.user_videos_user_resource.id
  path_part   = "videos"
  depends_on  = [aws_api_gateway_resource.user_videos_user_resource]
}

resource "aws_api_gateway_method" "get_user_videos" {
  rest_api_id   = aws_api_gateway_rest_api.api.id
  resource_id   = aws_api_gateway_resource.user_videos_user_videos_resource.id
  http_method   = "GET"
  authorization = "NONE"
  depends_on    = [aws_api_gateway_resource.user_videos_user_videos_resource]
}

resource "aws_api_gateway_integration" "lambda_integration" {
  rest_api_id             = aws_api_gateway_rest_api.api.id
  resource_id             = aws_api_gateway_resource.user_videos_user_videos_resource.id
  http_method             = aws_api_gateway_method.get_user_videos.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.lambda_status.invoke_arn
  depends_on              = [aws_api_gateway_method.get_user_videos]
}

resource "aws_api_gateway_deployment" "api_deployment" {
  depends_on = [
    aws_api_gateway_method.get_user_videos,
    aws_api_gateway_integration.lambda_integration
  ]

  rest_api_id = aws_api_gateway_rest_api.api.id
}

resource "aws_api_gateway_stage" "prod" {
  deployment_id = aws_api_gateway_deployment.api_deployment.id
  rest_api_id   = aws_api_gateway_rest_api.api.id
  stage_name    = "prod"
}

resource "aws_lambda_permission" "api_gateway_lambda" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambda_status.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.api.execution_arn}/*/*"
}