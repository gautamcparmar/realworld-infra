variable "name_prefix" {
  type = string
}

variable "sns_topic_arn" {
  type = string
}

variable "rds_instance_id" {
  type = string
}

variable "cloudfront_distribution_id" {
  type = string
}

variable "api_id" {
  type = string
}

variable "monthly_budget_usd" {
  type = number
}

variable "aws_region" {
  description = "AWS region used on CloudWatch dashboard widgets."
  type        = string
}

variable "tags" {
  type    = map(string)
  default = {}
}
