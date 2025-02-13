
resource "aws_iam_role" "api_gateway_role" {
  name = "APIGatewayCognitoRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "apigateway.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_policy" "api_gateway_cognito_policy" {
  name        = "APIGatewayCognitoPolicy"
  description = "Policy for API Gateway to use Cognito"
  
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "cognito-idp:DescribeUserPool",
          "cognito-idp:ListUsers",
          "cognito-idp:AdminGetUser"
        ]
        Effect   = "Allow"
        Resource = var.cognito_user_pool_arn
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "api_gateway_cognito_policy_attachment" {
  role       = aws_iam_role.api_gateway_role.name
  policy_arn = aws_iam_policy.api_gateway_cognito_policy.arn
}

resource "aws_api_gateway_authorizer" "cognito_authorizer" {
  name          = "CognitoAuthorizer"
  rest_api_id   = var.api_id
  type          = "COGNITO_USER_POOLS"
  provider_arns = [var.cognito_user_pool_arn]
  identity_source = "method.request.header.Authorization"
}

/*resource "aws_api_gateway_method" "methods" {
  rest_api_id   = var.api_id
  resource_id   = var.video_resource_id
  http_method   = "GET"
  authorization = "COGNITO_USER_POOLS"
  authorizer_id = aws_api_gateway_authorizer.cognito_authorizer.id
}*/
