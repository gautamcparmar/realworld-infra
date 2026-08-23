output "function_name" {
  value = aws_lambda_function.this.function_name
}

output "function_arn" {
  value = aws_lambda_function.this.arn
}

output "alias_name" {
  value = aws_lambda_alias.live.name
}

output "alias_arn" {
  value = aws_lambda_alias.live.arn
}

output "invoke_arn" {
  value = aws_lambda_alias.live.invoke_arn
}

output "codedeploy_application_name" {
  value = aws_codedeploy_app.this.name
}

output "codedeploy_deployment_group_name" {
  value = aws_codedeploy_deployment_group.this.deployment_group_name
}

output "codedeploy_service_role_arn" {
  value = aws_iam_role.codedeploy.arn
}
