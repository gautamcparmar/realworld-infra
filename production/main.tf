module "kms" {
  source = "../modules/kms"

  name_prefix   = local.name_prefix
  account_id    = local.account_id
  aws_region    = local.aws_region
  aws_partition = local.aws_partition
  tags          = local.common_tags
}

module "vpc" {
  source = "../modules/vpc"

  name_prefix        = local.name_prefix
  cidr_block         = var.vpc_cidr
  availability_zones = local.azs
  aws_region         = local.aws_region
  tags               = local.common_tags
}

module "security_groups" {
  source = "../modules/security_groups"

  name_prefix             = local.name_prefix
  vpc_id                  = module.vpc.vpc_id
  rds_allowed_cidr_blocks = var.rds_allowed_cidr_blocks
  tags                    = local.common_tags
}

module "rds" {
  source = "../modules/rds"

  name_prefix              = local.name_prefix
  database_subnet_ids      = module.vpc.database_subnet_ids
  rds_security_group_id    = module.security_groups.rds_security_group_id
  engine_version           = var.rds_engine_version
  instance_class           = local.rds_instance_class
  allocated_storage        = var.rds_allocated_storage
  max_allocated_storage    = var.rds_max_allocated_storage
  multi_az                 = local.rds_multi_az
  backup_retention_period  = local.rds_backup_days
  kms_key_arn              = module.kms.key_arn
  deletion_protection      = local.destroy_protection
  skip_final_snapshot      = !local.is_production
  log_retention_days       = local.log_retention_days
  tags                     = local.common_tags
}

module "frontend_bucket" {
  source = "../modules/s3_bucket"

  bucket_name            = local.frontend_bucket_name
  kms_key_arn            = module.kms.key_arn
  force_destroy          = local.force_destroy
  additional_policy_json = data.aws_iam_policy_document.frontend_bucket.json
  tags                   = merge(local.common_tags, { Purpose = "frontend" })
}

module "apigateway" {
  source = "../modules/apigateway"

  name_prefix            = local.name_prefix
  kms_key_arn            = module.kms.key_arn
  log_retention_days     = local.log_retention_days
  throttling_burst_limit = local.is_production ? 200 : 50
  throttling_rate_limit  = local.is_production ? 100 : 25
  tags                   = local.common_tags
}

module "api_function" {
  source = "../modules/api_function"

  name_prefix          = local.name_prefix
  handler              = "lambda.handler"
  api_id               = module.apigateway.api_id
  api_execution_arn    = module.apigateway.execution_arn
  subnet_ids           = module.vpc.application_subnet_ids
  security_group_ids   = [module.security_groups.lambda_security_group_id]
  kms_key_arn          = module.kms.key_arn
  aws_region           = local.aws_region
  aws_account_id       = local.account_id
  aws_partition        = local.aws_partition
  log_retention_days   = local.log_retention_days
  ssm_parameter_prefix = "/${var.project_name}"
  db_secret_arn        = module.rds.master_user_secret_arn

  environment_variables = {
    POSTGRES_HOST = module.rds.endpoint,
    POSTGRES_PORT = module.rds.port,
    POSTGRES_DB = module.rds.db_name,
    JWT_SECRET = "secret",
    JWT_EXPIRES_IN = "7d"
  }
  tags = local.common_tags
}

module "cloudfront" {
  source                         = "../modules/cloudfront"
  name_prefix                    = local.name_prefix
  s3_bucket_arn                  = module.frontend_bucket.arn
  s3_bucket_regional_domain_name = module.frontend_bucket.bucket_regional_domain_name
  api_gateway_hostname           = module.apigateway.api_hostname
  api_path_pattern               = var.api_path_pattern
  price_class                    = local.price_class
  tags                           = local.common_tags
}

# module "monitoring" {
#   source = "../modules/monitoring"

#   name_prefix                = local.name_prefix
#   sns_topic_arn              = aws_sns_topic.alerts.arn
#   rds_instance_id            = module.rds.instance_id
#   cloudfront_distribution_id = module.cloudfront.distribution_id
#   api_id                     = module.apigateway.api_id
#   monthly_budget_usd         = var.monthly_budget_usd
#   aws_region                 = local.aws_region
#   tags                       = local.common_tags
# }
