variable "project_name" {
  description = "Short name used as a prefix on all resources."
  type        = string
  default     = "realworld"

  validation {
    condition     = can(regex("^[a-z0-9-]+$", var.project_name))
    error_message = "project_name must contain only lowercase letters, numbers, and hyphens."
  }
}

variable "environment" {
  description = "Deployment environment. Must be stage or production."
  type        = string

  validation {
    condition     = contains(["stage", "production"], var.environment)
    error_message = "environment must be \"stage\" or \"production\"."
  }
}

variable "owner" {
  description = "Owning team or individual. Applied as a tag."
  type        = string
  default     = "platform"
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC. Must be large enough for public, application, and database subnets in two AZs."
  type        = string
  default     = "10.20.0.0/16"
}

variable "rds_engine_version" {
  description = "PostgreSQL major/minor version for the application database."
  type        = string
  default     = "16"
}

variable "rds_instance_class" {
  description = "RDS instance class. Leave null to pick a safe default per environment."
  type        = string
  default     = null
}

variable "rds_allocated_storage" {
  description = "Initial allocated storage in GiB."
  type        = number
  default     = 20
}

variable "rds_max_allocated_storage" {
  description = "Storage autoscaling ceiling in GiB."
  type        = number
  default     = 100
}

variable "rds_multi_az" {
  description = "Enable Multi-AZ RDS. Null selects Multi-AZ for production and single-AZ for stage."
  type        = bool
  default     = null
}

variable "rds_backup_retention_days" {
  description = "Automated backup retention. Null selects 30 days for production and 7 days for stage."
  type        = number
  default     = null
}

variable "rds_allowed_cidr_blocks" {
  description = "Optional extra CIDR blocks allowed to reach RDS (break-glass). Leave empty in normal operation."
  type        = list(string)
  default     = []
}

variable "cloudfront_price_class" {
  description = "CloudFront price class. Null selects PriceClass_100 for stage and PriceClass_All for production."
  type        = string
  default     = null
}

variable "api_path_pattern" {
  description = "CloudFront path pattern forwarded to API Gateway without caching."
  type        = string
  default     = "/api/*"
}

variable "approval_email_addresses" {
  description = "Email addresses subscribed to CloudWatch alarm and budget notifications."
  type        = list(string)
  default     = []
}

variable "log_retention_days" {
  description = "CloudWatch log retention in days. Null selects 90 for production and 30 for stage."
  type        = number
  default     = null
}

variable "monthly_budget_usd" {
  description = "Monthly cost budget in USD. Alerts publish to the notification topic."
  type        = number
  default     = 150
}

variable "enable_destroy_protection" {
  description = "Protect RDS and CloudFront from destroy. Null enables protection for production only."
  type        = bool
  default     = null
}

variable "force_destroy_buckets" {
  description = "Allow Terraform to delete buckets that still contain objects. Null enables this for stage only."
  type        = bool
  default     = null
}
