data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

data "aws_partition" "current" {}

data "aws_availability_zones" "available" {
  state = "available"
}

data "aws_ssm_parameter" "frontend_codebuild_role_arn" {
  name = "/${var.project_name}/shared/cicd/frontend-codebuild-role-arn"
}
