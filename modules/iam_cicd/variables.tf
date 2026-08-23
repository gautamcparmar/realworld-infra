variable "project_name" {
  description = "Short project name used in role names and SSM paths."
  type        = string
}

variable "component" {
  description = "frontend or backend. Controls role names and CodeBuild permissions."
  type        = string

  validation {
    condition     = contains(["frontend", "backend"], var.component)
    error_message = "component must be frontend or backend."
  }
}

variable "aws_region" {
  type = string
}

variable "aws_account_id" {
  type = string
}

variable "aws_partition" {
  type    = string
  default = "aws"
}

variable "artifacts_bucket_arn" {
  type = string
}

variable "kms_key_arn" {
  type = string
}

variable "codestar_connection_arn" {
  type = string
}

variable "approval_sns_topic_arn" {
  type = string
}

variable "tags" {
  type    = map(string)
  default = {}
}
