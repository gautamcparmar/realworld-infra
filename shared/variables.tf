variable "project_name" {
  description = "Short name used as a prefix on shared CI/CD resources."
  type        = string
  default     = "realworld"

  validation {
    condition     = can(regex("^[a-z0-9-]+$", var.project_name))
    error_message = "project_name must contain only lowercase letters, numbers, and hyphens."
  }
}

variable "owner" {
  type    = string
  default = "platform"
}

variable "codestar_connection_arn" {
  description = "Existing CodeStar connection ARN. If empty, Terraform creates a GitHub connection that must be authorized in the console."
  type        = string
  default     = ""
}

variable "codestar_provider_type" {
  type    = string
  default = "GitHub"
}

variable "frontend_repository_id" {
  description = "Full repository id for the Angular app, for example org/realworld-frontend."
  type        = string
}

variable "backend_repository_id" {
  description = "Full repository id for the NestJS app, for example org/realworld-backend."
  type        = string
}

variable "source_branch" {
  type    = string
  default = "main"
}

variable "frontend_buildspec_validate" {
  type    = string
  default = "scripts/buildspec-validate.yml"
}

variable "frontend_buildspec_build" {
  type    = string
  default = "scripts/buildspec-build.yml"
}

variable "frontend_buildspec_test" {
  type    = string
  default = "scripts/buildspec-test.yml"
}

variable "frontend_buildspec_deploy" {
  type    = string
  default = "scripts/buildspec-deploy.yml"
}

variable "frontend_buildspec_perf_test" {
  description = "Buildspec that runs k6 against staging after Deploy-Stage. Empty disables the stage."
  type        = string
  default     = "scripts/buildspec-perf-test.yml"
}

variable "backend_buildspec_validate" {
  type    = string
  default = "scripts/buildspec-validate.yml"
}

variable "backend_buildspec_build" {
  type    = string
  default = "scripts/buildspec-build.yml"
}

variable "backend_buildspec_test" {
  type    = string
  default = "scripts/buildspec-test.yml"
}

variable "backend_buildspec_deploy" {
  type    = string
  default = "scripts/buildspec-deploy.yml"
}

variable "backend_buildspec_perf_test" {
  description = "Buildspec that runs k6 against staging after Deploy-Stage. Empty disables the stage."
  type        = string
  default     = "scripts/buildspec-perf-test.yml"
}

variable "require_production_approval" {
  description = "Require a manual approval between Deploy-Stage and Deploy-Production."
  type        = bool
  default     = true
}

variable "approval_email_addresses" {
  type    = list(string)
  default = []
}

variable "log_retention_days" {
  type    = number
  default = 30
}

variable "force_destroy_buckets" {
  type    = bool
  default = true
}
