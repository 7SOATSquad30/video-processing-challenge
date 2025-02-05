resource "aws_api_gateway_deployment" "deployment" {
  rest_api_id = var.api_id
}

resource "aws_api_gateway_stage" "stage" {
  deployment_id = aws_api_gateway_deployment.deployment.id
  rest_api_id   = var.api_id
  stage_name    = "v1"
}
