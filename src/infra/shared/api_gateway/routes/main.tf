resource "aws_api_gateway_method" "method" {
  rest_api_id   = var.api_id
  resource_id   = var.integration.resource_id
  http_method   = var.integration.http_method
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "integrations" {
  rest_api_id   = var.api_id
  resource_id   = aws_api_gateway_method.method.resource_id
  http_method   = aws_api_gateway_method.method.http_method
  type          = var.integration.integration_type
  integration_http_method   = var.integration.integration_http_method
  uri                       = var.integration.integration_uri
  passthrough_behavior      = var.integration.passthrough_behavior
  content_handling          = var.integration.content_handling
}