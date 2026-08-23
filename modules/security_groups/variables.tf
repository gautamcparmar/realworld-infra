variable "name_prefix" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "rds_port" {
  type    = number
  default = 5432
}

variable "rds_allowed_cidr_blocks" {
  description = "Optional extra CIDRs allowed to reach RDS."
  type        = list(string)
  default     = []
}

variable "tags" {
  type    = map(string)
  default = {}
}
