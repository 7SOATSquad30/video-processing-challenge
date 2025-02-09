# Cognito User Pool name
variable "user_pool_name" {
  description = "Cognito User Pool Name"
  type        = string
  default     = "fastfood-user-pool"
}

# Cognito User Pool ARN
/*variable "user_pool_arn" {
  description = "Cognito User Pool ARN"
  type        = string
}*/

# Cognito User Pool Domain Prefix
variable "user_pool_domain_prefix" {
  description = "Cognito domain prefix"
  type        = string
  default     = "fastfood-domain"
}

# Cognito Cliente name
variable "client_name" {
  description = "Cognito client name"
  type        = string
  default     = "fastfood-client"
}

# Cognito Callback URLs
variable "callback_urls" {
  description = "Allowed URLs for Cognito callbacks"
  type        = list(string)
  default     = ["https://example.com/callback"]
}

# Cognito Identity Pool name
variable "identity_pool_name" {
  description = "Identity Pool Name"
  type        = string
  default     = "fastfood-identity-pool"
}

variable "app_client_name" {
  type        = string
}

variable "cognito_domain" {
  type        = string
}

variable "logout_urls" {
  type        = list(string)
}

/*
# Lambda function ARN for the Pre Token Generation trigger
variable "lambda_function_arn" {
  description = "Lambda function ARN for the Pre Token Generation trigger"
  type        = string
}*/

/*variable "environment" {
  description = "The environment"
  type        = string
}*/

variable "user_email" {
  default = "user.test@hotmail.com"
}

variable "user_password" {
  default = "UserTest@321"
}
