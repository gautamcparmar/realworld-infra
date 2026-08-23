output "environment" {
  value = var.environment
}

output "alerts_topic_arn" {
  value = aws_sns_topic.alerts.arn
}

output "vpc_id" {
  value = module.vpc.vpc_id
}

output "public_subnet_ids" {
  value = module.vpc.public_subnet_ids
}

output "application_subnet_ids" {
  value = module.vpc.application_subnet_ids
}

output "database_subnet_ids" {
  value = module.vpc.database_subnet_ids
}

output "lambda_security_group_id" {
  value = module.security_groups.lambda_security_group_id
}

output "rds_security_group_id" {
  value = module.security_groups.rds_security_group_id
}

# output "rds_endpoint" {
#   value = module.rds.endpoint
# }

# output "rds_secret_arn" {
#   value     = module.rds.master_user_secret_arn
#   sensitive = true
# }

output "frontend_bucket" {
  value = module.frontend_bucket.id
}

output "http_api_id" {
  description = "HTTP API that the NestJS backend attaches routes to."
  value       = module.apigateway.api_id
}

output "api_function_name" {
  value = module.api_function.function_name
}

output "api_function_alias" {
  value = module.api_function.alias_name
}

output "codedeploy_application_name" {
  value = module.api_function.codedeploy_application_name
}

output "cloudfront_domain_name" {
  value = module.cloudfront.domain_name
}

output "cloudfront_distribution_id" {
  value = module.cloudfront.distribution_id
}

output "application_url" {
  value = "https://${module.cloudfront.domain_name}"
}

output "ssm_parameter_prefix" {
  value = "/${var.project_name}/${var.environment}"
}
