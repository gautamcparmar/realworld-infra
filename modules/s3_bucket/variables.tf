variable "bucket_name" {
  type = string
}

variable "kms_key_arn" {
  description = "Customer managed key for SSE-KMS. When null, SSE-S3 (AES256) is used."
  type        = string
  default     = null
}

variable "force_destroy" {
  type    = bool
  default = false
}

variable "enable_versioning" {
  type    = bool
  default = true
}

variable "object_ownership" {
  description = "S3 object ownership. Use BucketOwnerPreferred only when ACLs are required (CloudFront classic logs)."
  type        = string
  default     = "BucketOwnerEnforced"
}

variable "enable_acl" {
  type    = bool
  default = false
}

variable "acl" {
  type    = string
  default = "private"
}

variable "noncurrent_version_expiration_days" {
  type    = number
  default = 90
}

variable "abort_multipart_days" {
  type    = number
  default = 7
}

variable "expire_current_days" {
  description = "Optional expiration for current object versions (use for log buckets)."
  type        = number
  default     = null
}

variable "additional_policy_json" {
  description = "Optional extra bucket policy JSON merged with the TLS-only baseline."
  type        = string
  default     = null
}

variable "attach_policy" {
  type    = bool
  default = true
}

variable "block_public_acls" {
  type    = bool
  default = true
}

variable "ignore_public_acls" {
  type    = bool
  default = true
}

variable "block_public_policy" {
  type    = bool
  default = true
}

variable "restrict_public_buckets" {
  type    = bool
  default = true
}

variable "tags" {
  type    = map(string)
  default = {}
}
