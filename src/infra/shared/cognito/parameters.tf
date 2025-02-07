# Store the User Pool ID in the Parameter Store
resource "aws_ssm_parameter" "user_pool" {
  name  = "/cognito/user_pool"
  type  = "String"
  value = aws_cognito_user_pool.user_pool.id
}

# Store the User Pool Client ID in the Parameter Store
resource "aws_ssm_parameter" "client" {
  name  = "/cognito/client"
  type  = "String"
  value = aws_cognito_user_pool_client.client.id
}

# Store the Admin Group ID in the Parameter Store
resource "aws_ssm_parameter" "admin_group" {
  name  = "/cognito/admin_group"
  type  = "String"
  value = aws_cognito_user_group.admin_group.id
}

# Store the Customer Grou ID in the Parameter Store
resource "aws_ssm_parameter" "customer_group" {
  name  = "/cognito/customer_group"
  type  = "String"
  value = aws_cognito_user_group.customer_group.id
}

# Store the Identity Pool ID in the Parameter Store
resource "aws_ssm_parameter" "identity_pool" {
  name  = "/cognito/identity_pool"
  type  = "String"
  value = aws_cognito_identity_pool.identity_pool.id
}
