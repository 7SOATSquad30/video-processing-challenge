variable "role_name" {
  type = string
}

variable "assume_role_policy" {
  description = "The assume role policy document for the IAM role"
  type        = string
}

variable "policy_statements" {
  description = "Additional policy statements to attach to the role"
  type        = list(object({
    Action    = list(string)
    Resource  = list(string)
    Effect    = optional(string, "Allow")
  }))
  default = []
}
