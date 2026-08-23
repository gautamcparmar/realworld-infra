variable "name_prefix" {
  type = string
}

variable "kms_key_arn" {
  type = string
}

variable "log_retention_days" {
  type = number
}

variable "throttling_burst_limit" {
  type = number
}

variable "throttling_rate_limit" {
  type = number
}

variable "cors_allow_origins" {
  type    = list(string)
  default = ["*"]
}

variable "tags" {
  type    = map(string)
  default = {}
}
