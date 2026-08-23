module "kms" {
  source = "../modules/kms"

  name_prefix   = "${local.name_prefix}-cicd"
  account_id    = local.account_id
  aws_region    = local.aws_region
  aws_partition = local.aws_partition
  tags          = local.common_tags
}

module "artifacts_bucket" {
  source = "../modules/s3_bucket"

  bucket_name            = local.artifacts_bucket_name
  kms_key_arn            = module.kms.key_arn
  force_destroy          = var.force_destroy_buckets
  additional_policy_json = data.aws_iam_policy_document.artifacts_bucket.json
  tags                   = merge(local.common_tags, { Purpose = "release-artifacts" })
}

module "frontend_iam" {
  source = "../modules/iam_cicd"

  project_name            = var.project_name
  component               = "frontend"
  aws_region              = local.aws_region
  aws_account_id          = local.account_id
  aws_partition           = local.aws_partition
  artifacts_bucket_arn    = module.artifacts_bucket.arn
  kms_key_arn             = module.kms.key_arn
  codestar_connection_arn = local.codestar_connection_arn
  approval_sns_topic_arn  = aws_sns_topic.approvals.arn
  tags                    = local.common_tags
}

module "backend_iam" {
  source = "../modules/iam_cicd"

  project_name             = var.project_name
  component                = "backend"
  aws_region               = local.aws_region
  aws_account_id           = local.account_id
  aws_partition            = local.aws_partition
  artifacts_bucket_arn     = module.artifacts_bucket.arn
  kms_key_arn              = module.kms.key_arn
  codestar_connection_arn  = local.codestar_connection_arn
  approval_sns_topic_arn   = aws_sns_topic.approvals.arn
  tags                     = local.common_tags
}

module "frontend_pipeline" {
  source = "../modules/codepipeline"

  project_name                = var.project_name
  component                   = "frontend"
  aws_region                  = local.aws_region
  aws_account_id              = local.account_id
  aws_partition               = local.aws_partition
  kms_key_arn                 = module.kms.key_arn
  artifacts_bucket_name       = module.artifacts_bucket.id
  codepipeline_role_arn       = module.frontend_iam.codepipeline_role_arn
  codebuild_role_arn          = module.frontend_iam.codebuild_role_arn
  codestar_connection_arn     = local.codestar_connection_arn
  repository_id               = var.frontend_repository_id
  source_branch               = var.source_branch
  buildspec_validate          = var.frontend_buildspec_validate
  buildspec_build             = var.frontend_buildspec_build
  buildspec_test              = var.frontend_buildspec_test
  buildspec_deploy            = var.frontend_buildspec_deploy
  require_production_approval = var.require_production_approval
  approval_sns_topic_arn      = aws_sns_topic.approvals.arn
  log_retention_days          = var.log_retention_days
  environment_variables = {
    SSM_BASE_PATH         = "/${var.project_name}"
    NG_CONFIGURATION      = "production"
    CLOUDFRONT_ORIGIN_ID  = "s3-frontend"
  }
  tags = local.common_tags
}

module "backend_pipeline" {
  source = "../modules/codepipeline"

  project_name                = var.project_name
  component                   = "backend"
  aws_region                  = local.aws_region
  aws_account_id              = local.account_id
  aws_partition               = local.aws_partition
  kms_key_arn                 = module.kms.key_arn
  artifacts_bucket_name       = module.artifacts_bucket.id
  codepipeline_role_arn       = module.backend_iam.codepipeline_role_arn
  codebuild_role_arn          = module.backend_iam.codebuild_role_arn
  codestar_connection_arn     = local.codestar_connection_arn
  repository_id               = var.backend_repository_id
  source_branch               = var.source_branch
  buildspec_validate          = var.backend_buildspec_validate
  buildspec_build             = var.backend_buildspec_build
  buildspec_test              = var.backend_buildspec_test
  buildspec_deploy            = var.backend_buildspec_deploy
  require_production_approval = var.require_production_approval
  approval_sns_topic_arn      = aws_sns_topic.approvals.arn
  log_retention_days          = var.log_retention_days
  environment_variables = {
    SSM_BASE_PATH = "/${var.project_name}"
  }
  tags = local.common_tags
}
