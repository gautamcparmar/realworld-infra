variable "name_prefix" {
  description = "Prefix used on VPC resources."
  type        = string
}

variable "cidr_block" {
  description = "VPC IPv4 CIDR."
  type        = string
}

variable "availability_zones" {
  description = "Exactly two availability zones."
  type        = list(string)

  validation {
    condition     = length(var.availability_zones) == 2
    error_message = "Provide exactly two availability zones."
  }
}

variable "aws_region" {
  description = "AWS region used for the S3 gateway endpoint service name."
  type        = string
}

variable "tags" {
  description = "Additional tags."
  type        = map(string)
  default     = {}
}
