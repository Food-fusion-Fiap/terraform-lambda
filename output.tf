output "lambda_authorizer_invoke_arn" {
  description = "Invoke arn from lambda authorizer"
  value       = aws_lambda_function.lambda_authorizer.invoke_arn
}

output "lambda_authenticate_function_name" {
  description = "Lambda authenticate name"
  value       = aws_lambda_function.lambda_auth.function_name
}

output "lambda_authorizer_function_name" {
  description = "Lambda authorizer name"
  value       = aws_lambda_function.lambda_authorizer.function_name
}