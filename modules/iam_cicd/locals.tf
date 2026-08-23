locals {
  pipeline_name = "${var.project_name}-${var.component}"

  codebuild_project_arn = "arn:${var.aws_partition}:codebuild:${var.aws_region}:${var.aws_account_id}:project/${local.pipeline_name}-*"
}
