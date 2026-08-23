locals {
  ssm_prefix = "/${var.project_name}/shared"
}

resource "aws_ssm_parameter" "artifacts_bucket" {
  name  = "${local.ssm_prefix}/artifacts/bucket"
  type  = "String"
  value = module.artifacts_bucket.id
}

resource "aws_ssm_parameter" "artifacts_bucket_arn" {
  name  = "${local.ssm_prefix}/artifacts/bucket-arn"
  type  = "String"
  value = module.artifacts_bucket.arn
}

resource "aws_ssm_parameter" "kms_key_arn" {
  name  = "${local.ssm_prefix}/kms/key-arn"
  type  = "String"
  value = module.kms.key_arn
}

resource "aws_ssm_parameter" "frontend_codebuild_role_arn" {
  name  = "${local.ssm_prefix}/cicd/frontend-codebuild-role-arn"
  type  = "String"
  value = module.frontend_iam.codebuild_role_arn
}

# resource "aws_ssm_parameter" "backend_codebuild_role_arn" {
#   name  = "${local.ssm_prefix}/cicd/backend-codebuild-role-arn"
#   type  = "String"
#   value = module.backend_iam.codebuild_role_arn
# }
