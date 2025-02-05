variable "api_id" {
    type = string
}

variable "api_root_resource_id" {
    type = string
}

variable "routes" {
  type = list(object({
    path_parts = list(string)
    http_method = string
    integration_type = string
    integration_http_method = string
    integration_uri = string
    passthrough_behavior = string
    content_handling = string
  }))
}
