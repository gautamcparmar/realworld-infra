variable "name_prefix" {
  type = string
}

variable "s3_bucket_arn" {
  type = string
}

variable "s3_bucket_regional_domain_name" {
  type = string
}

variable "api_gateway_hostname" {
  description = "API Gateway execute-api hostname (no scheme)."
  type        = string
}

variable "api_path_pattern" {
  type = string
}

variable "price_class" {
  type = string
}

variable "tags" {
  type    = map(string)
  default = {}
}
