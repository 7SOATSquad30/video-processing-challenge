variable "aws_region" {
  description = "AWS region where resources will be created"
  type        = string
  default     = "us-east-1"
}

variable "tf_state_bucket_name" {
  type = string
  default = "fiap-challenge-terraform-state"
}

variable "s3_use_path_style" {
  type = bool
  default = false
}