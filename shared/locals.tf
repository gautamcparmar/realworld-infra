locals {
  name_prefix   = var.project_name
  account_id    = data.aws_caller_identity.current.account_id
  aws_region    = data.aws_region.current.region
  aws_partition = data.aws_partition.current.partition

  artifacts_bucket_name = "${var.project_name}-artifacts-${random_id.suffix.hex}"

  codestar_connection_arn = var.codestar_connection_arn != "" ? var.codestar_connection_arn : aws_codestarconnections_connection.github[0].arn

  common_tags = {
    Project     = var.project_name
    Environment = "shared"
    ManagedBy   = "terraform"
    Owner       = var.owner
  }
}

resource "random_id" "suffix" {
  byte_length = 4
}
