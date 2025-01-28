locals {
  account_id     = data.aws_caller_identity.current.account_id
  component_name = "upload-lambda"
  lambdas_path   = "${path.module}/../dist"
}
