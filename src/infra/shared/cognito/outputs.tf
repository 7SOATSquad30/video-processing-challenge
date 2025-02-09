# Cognito User Pool ID
output "user_pool_id" {
  description = "ID do User Pool"
  value       = aws_cognito_user_pool.user_pool.id
}

# ARN User Pool
output "user_pool_arn" {
  description = "ARN do User Pool"
  value       = aws_cognito_user_pool.user_pool.arn
}

# Cognito Client ID
output "client_id" {
  description = "ID do Client"
  value       = aws_cognito_user_pool_client.client.id
}

# Cognito Identity Pool ID
output "identity_pool_id" {
  description = "ID do Identity Pool"
  value       = aws_cognito_identity_pool.identity_pool.id
}

# Cognito User Pool Domain
output "user_pool_domain" {
  description = "Cognito User Pool Domain"
  value       = aws_cognito_user_pool_domain.user_pool_domain.domain
}

# Cognito Domain
output "cognito_domain" {
  description = "Cognito Domain"
  value       = aws_cognito_user_pool_domain.user_pool_domain.domain
}
