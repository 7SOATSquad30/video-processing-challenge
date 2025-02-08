resource "aws_api_gateway_resource" "resource_1" {
  rest_api_id = var.api_id
  parent_id   = var.api_root_resource_id
  path_part   = "users"
}

resource "aws_api_gateway_resource" "resource_2" {
  rest_api_id = var.api_id
  parent_id   = aws_api_gateway_resource.resource_1.id
  path_part   = "{userId}"
  
  depends_on = [aws_api_gateway_resource.resource_1]
}

resource "aws_api_gateway_resource" "resource_3" {
  rest_api_id = var.api_id
  parent_id   = aws_api_gateway_resource.resource_2.id
  path_part   = "videos"
  
  depends_on = [aws_api_gateway_resource.resource_2]
}

resource "aws_api_gateway_resource" "resource_4" {
  rest_api_id = var.api_id
  parent_id   = aws_api_gateway_resource.resource_2.id
  path_part   = "signedUploadUrl"
  
  depends_on = [aws_api_gateway_resource.resource_2]
}
