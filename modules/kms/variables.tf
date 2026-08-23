variable "name_prefix" {
  description = "Prefix used in the KMS alias."
  type        = string
}

variable "account_id" {
  description = "AWS account ID that owns the key."
  type        = string
}

variable "aws_region" {
  description = "AWS region used in the key policy (CloudWatch Logs and service principals)."
  type        = string
}

variable "aws_partition" {
  description = "AWS partition, for example aws, aws-us-gov, or aws-cn."
  type        = string
  default     = "aws"
}

variable "enable_key_rotation" {
  description = "Enable automatic yearly key rotation."
  type        = bool
  default     = true
}

variable "deletion_window_in_days" {
  description = "Waiting period before the key is deleted."
  type        = number
  default     = 30
}

variable "tags" {
  description = "Additional tags."
  type        = map(string)
  default     = {}
}
