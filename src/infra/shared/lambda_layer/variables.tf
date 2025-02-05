variable "layer_name" {
  type = string
}

variable "layer_bucket_name" {
  type = string
}

variable "layer_bucket_key" {
  type = string
}

variable "layer_zipfile_path" {
  type = string
}

variable "layer_compatible_runtimes" {
  type        = list(string)
  default     = []
}