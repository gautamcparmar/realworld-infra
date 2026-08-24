variable "name_prefix" {
  type = string
}

variable "api_id" {
  description = "HTTP API id that receives this function."
  type        = string
}

variable "api_execution_arn" {
  description = "HTTP API execution ARN used for Lambda invoke permission."
  type        = string
}

variable "subnet_ids" {
  description = "Application subnet IDs for the Lambda ENIs."
  type        = list(string)
}

variable "security_group_ids" {
  description = "Security groups attached to the Lambda ENIs."
  type        = list(string)
}

variable "kms_key_arn" {
  type = string
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

variable "log_retention_days" {
  type = number
}

variable "runtime" {
  type    = string
  default = "nodejs22.x"
}

variable "handler" {
  type    = string
  default = "index.handler"
}

variable "memory_size" {
  type    = number
  default = 512
}

variable "timeout" {
  type    = number
  default = 29
}

variable "alias_name" {
  description = "Lambda alias CodeDeploy shifts traffic onto."
  type        = string
  default     = "live"
}

variable "deployment_config_name" {
  description = "CodeDeploy Lambda traffic-shifting configuration."
  type        = string
  default     = "CodeDeployDefault.LambdaAllAtOnce"
}

variable "environment_variables" {
  type    = map(string)
  default = {}
}

variable "ssm_parameter_prefix" {
  description = "SSM path the function may read, for example /realworld."
  type        = string
}

variable "db_secret_arn" {
  description = "RDS master user secret ARN. Used when enable_db_secret_access is true."
  type        = string
  default     = null
}

variable "enable_db_secret_access" {
  description = "Grant the function role access to db_secret_arn. Must be known at plan time."
  type        = bool
  default     = false
}

variable "tags" {
  type    = map(string)
  default = {}
}
