variable "api_id" {
    type = string
}

variable "api_root_resource_id" {
    type = string
}

variable "integration" {
  type = object({
    http_method = string
    resource_id = string
    integration_type = string
    integration_http_method = string
    integration_uri = string
    passthrough_behavior = string
    content_handling = string
  })
}

variable "cognito_authorizer_id" {
  type = string
}

variable "cognito_authorizer" {
  type = string
}