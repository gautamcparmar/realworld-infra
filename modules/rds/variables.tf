variable "name_prefix" {
  type = string
}

variable "database_subnet_ids" {
  type = list(string)
}

variable "rds_security_group_id" {
  type = string
}

variable "engine_version" {
  type = string
}

variable "instance_class" {
  type = string
}

variable "allocated_storage" {
  type = number
}

variable "max_allocated_storage" {
  type = number
}

variable "multi_az" {
  type = bool
}

variable "backup_retention_period" {
  type = number
}

variable "backup_schedule" {
  description = "AWS Backup cron expression in UTC for the daily RDS backup."
  type        = string
  default     = "cron(0 7 * * ? *)"
}

variable "kms_key_arn" {
  type = string
}

variable "deletion_protection" {
  type = bool
}

variable "skip_final_snapshot" {
  type = bool
}

variable "log_retention_days" {
  type = number
}

variable "tags" {
  type    = map(string)
  default = {}
}
