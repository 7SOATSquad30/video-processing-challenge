resource "aws_api_gateway_resource" "resource_1" {
  for_each   = { for idx, route in var.routes : idx => route }
  rest_api_id = var.api_id
  parent_id   = var.api_root_resource_id
  path_part   = each.value.path_parts[0]
}

resource "aws_api_gateway_resource" "resource_2" {
  for_each = { for idx, route in var.routes : idx => route }
  
  rest_api_id = var.api_id
  parent_id   = aws_api_gateway_resource.resource_1[each.key].id
  path_part   = each.value.path_parts[1]
  
  depends_on = [aws_api_gateway_resource.resource_1]
}

resource "aws_api_gateway_resource" "resource_3" {
  for_each = { for idx, route in var.routes : idx => route }

  rest_api_id = var.api_id
  parent_id   = aws_api_gateway_resource.resource_2[each.key].id
  path_part   = each.value.path_parts[2]
  
  depends_on = [aws_api_gateway_resource.resource_2]
}

resource "aws_api_gateway_method" "methods" {
  for_each      = aws_api_gateway_resource.resource_3
  rest_api_id   = var.api_id
  resource_id   = each.value.id
  http_method   = var.routes[tonumber(each.key)].http_method
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "integrations" {
  for_each      = aws_api_gateway_method.methods
  rest_api_id   = var.api_id
  resource_id   = each.value.resource_id
  http_method   = each.value.http_method
  type          = var.routes[tonumber(each.key)].integration_type
  integration_http_method   = var.routes[tonumber(each.key)].integration_http_method
  uri                       = var.routes[tonumber(each.key)].integration_uri
  passthrough_behavior      = var.routes[tonumber(each.key)].passthrough_behavior
  content_handling          = var.routes[tonumber(each.key)].content_handling
}