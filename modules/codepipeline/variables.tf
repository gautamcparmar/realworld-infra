variable "project_name" {
  description = "Short project name used in resource names and SSM paths, for example realworld."
  type        = string
}

variable "component" {
  description = "frontend or backend. Controls artifact file name and optional VPC placement."
  type        = string

  validation {
    condition     = contains(["frontend", "backend"], var.component)
    error_message = "component must be frontend or backend."
  }
}

variable "kms_key_arn" {
  type = string
}

variable "aws_region" {
  description = "AWS region used to build IAM ARNs and CodeBuild environment variables."
  type        = string
}

variable "aws_account_id" {
  description = "AWS account ID used to build IAM ARNs and CodeBuild environment variables."
  type        = string
}

variable "aws_partition" {
  description = "AWS partition, for example aws, aws-us-gov, or aws-cn."
  type        = string
  default     = "aws"
}

variable "artifacts_bucket_name" {
  type = string
}

variable "codestar_connection_arn" {
  type = string
}

variable "repository_id" {
  description = "Full repository id, for example org/realworld-frontend."
  type        = string
}

variable "source_branch" {
  type = string
}

variable "buildspec_validate" {
  type = string
}

variable "buildspec_build" {
  type = string
}

variable "buildspec_test" {
  type = string
}

variable "buildspec_deploy" {
  type = string
}

variable "require_production_approval" {
  description = "Insert a manual approval action between stage deploy and production deploy."
  type        = bool
  default     = true
}

variable "approval_sns_topic_arn" {
  type = string
}

variable "log_retention_days" {
  type = number
}

variable "codebuild_image" {
  type    = string
  default = "aws/codebuild/standard:7.0"
}

variable "codebuild_compute_type" {
  type    = string
  default = "BUILD_GENERAL1_SMALL"
}

variable "privileged_mode" {
  description = "Enable Docker-in-Docker when a build needs to run containers."
  type        = bool
  default     = false
}

variable "vpc_config" {
  description = "Optional VPC placement for CodeBuild. Used by the backend pipeline so tests can reach RDS."
  type = object({
    vpc_id             = string
    subnets            = list(string)
    security_group_ids = list(string)
  })
  default = null
}

variable "environment_variables" {
  description = "Extra environment variables injected into every CodeBuild project for this pipeline."
  type        = map(string)
  default     = {}
}

variable "codepipeline_role_arn" {
  description = "Account-scoped CodePipeline service role created by the IAM module."
  type        = string
}

variable "codebuild_role_arn" {
  description = "Account-scoped CodeBuild service role created by the IAM module."
  type        = string
}

variable "tags" {
  type    = map(string)
  default = {}
}
