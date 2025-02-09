variable "lambda_name" {
  type = string
}

variable "lambda_iam_role_to_assume_arn" {
  type = string
}

variable "lambda_output_path" {
  type = string
}

variable "lambda_handler" {
  type = string
}

variable "lambda_runtime" {
  type = string
}

variable "lambda_timeout" {
  type = number
}

variable "lambda_memsize" {
  type = number
}

variable "lambda_environment" {
  description = "Environment variables for Lambda function"
  type        = map(string)
  default     = {}
}

variable "lambda_layers" {
  description = "Optional Lambda layers"
  type        = list(string)
  default     = []
}

variable "lambda_ephemeral_storage" {
  description = "Optional ephemeral storage for Lambda function (in MB)"
  type        = number
  default     = 2048
}

variable "lambda_arch" {
  type = list(string)
  default = ["arm64"]
}