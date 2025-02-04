locals {
  account_id     = data.aws_caller_identity.current.account_id
  component_name = "lambda-upload-video"
  #lambdas_path   = "${path.module}/../dist"
  lambdas_path = "./../../lambda-upload-video/dist"
}
