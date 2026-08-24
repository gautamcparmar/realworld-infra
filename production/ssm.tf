locals {
  ssm_prefix = "/${var.project_name}/${var.environment}"
}

resource "aws_ssm_parameter" "vpc_id" {
  name  = "${local.ssm_prefix}/vpc/id"
  type  = "String"
  value = module.vpc.vpc_id
}

resource "aws_ssm_parameter" "application_subnet_ids" {
  name  = "${local.ssm_prefix}/vpc/application-subnet-ids"
  type  = "StringList"
  value = join(",", module.vpc.application_subnet_ids)
}

resource "aws_ssm_parameter" "lambda_security_group_id" {
  name  = "${local.ssm_prefix}/vpc/lambda-security-group-id"
  type  = "String"
  value = module.security_groups.lambda_security_group_id
}

resource "aws_ssm_parameter" "http_api_id" {
  name  = "${local.ssm_prefix}/api/http-api-id"
  type  = "String"
  value = module.apigateway.api_id
}

resource "aws_ssm_parameter" "api_function_name" {
  name  = "${local.ssm_prefix}/api/function-name"
  type  = "String"
  value = module.api_function.function_name
}

resource "aws_ssm_parameter" "api_alias_name" {
  name  = "${local.ssm_prefix}/api/alias-name"
  type  = "String"
  value = module.api_function.alias_name
}

resource "aws_ssm_parameter" "codedeploy_application" {
  name  = "${local.ssm_prefix}/api/codedeploy-application"
  type  = "String"
  value = module.api_function.codedeploy_application_name
}

resource "aws_ssm_parameter" "codedeploy_deployment_group" {
  name  = "${local.ssm_prefix}/api/codedeploy-deployment-group"
  type  = "String"
  value = module.api_function.codedeploy_deployment_group_name
}

resource "aws_ssm_parameter" "db_secret_arn" {
  name  = "${local.ssm_prefix}/rds/secret-arn"
  type  = "String"
  value = module.rds.master_user_secret_arn
}

resource "aws_ssm_parameter" "db_endpoint" {
  name  = "${local.ssm_prefix}/rds/endpoint"
  type  = "String"
  value = module.rds.endpoint
}

resource "aws_ssm_parameter" "frontend_bucket" {
  name  = "${local.ssm_prefix}/frontend/bucket"
  type  = "String"
  value = module.frontend_bucket.id
}

resource "aws_ssm_parameter" "cloudfront_distribution_id" {
  name  = "${local.ssm_prefix}/cloudfront/distribution-id"
  type  = "String"
  value = module.cloudfront.distribution_id
}

resource "aws_ssm_parameter" "cloudfront_s3_origin_id" {
  name  = "${local.ssm_prefix}/cloudfront/s3-origin-id"
  type  = "String"
  value = module.cloudfront.s3_origin_id
}

resource "aws_ssm_parameter" "kms_key_arn" {
  name  = "${local.ssm_prefix}/kms/key-arn"
  type  = "String"
  value = module.kms.key_arn
}

resource "aws_ssm_parameter" "api_url" {
  name  = "${local.ssm_prefix}/api/url"
  type  = "String"
  value = "https://${module.cloudfront.domain_name}"
}

resource "aws_ssm_parameter" "application_domain" {
  name  = "${local.ssm_prefix}/domain_name"
  type  = "String"
  value = module.cloudfront.domain_name
}