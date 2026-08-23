output "api_id" {
  value = aws_apigatewayv2_api.this.id
}

output "api_endpoint" {
  description = "HTTPS invoke URL including the scheme."
  value       = aws_apigatewayv2_api.this.api_endpoint
}

output "api_hostname" {
  description = "Hostname suitable for a CloudFront custom origin."
  value       = replace(aws_apigatewayv2_api.this.api_endpoint, "https://", "")
}

output "stage_arn" {
  value = aws_apigatewayv2_stage.default.arn
}

output "execution_arn" {
  value = aws_apigatewayv2_api.this.execution_arn
}
