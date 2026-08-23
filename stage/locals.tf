locals {
  name_prefix   = "${var.project_name}-${var.environment}"
  is_production = var.environment == "production"
  azs           = slice(data.aws_availability_zones.available.names, 0, 2)
  account_id    = data.aws_caller_identity.current.account_id
  aws_region    = data.aws_region.current.region
  aws_partition = data.aws_partition.current.partition

  rds_instance_class = coalesce(var.rds_instance_class, local.is_production ? "db.t4g.small" : "db.t4g.micro")
  rds_multi_az       = coalesce(var.rds_multi_az, local.is_production)
  rds_backup_days    = coalesce(var.rds_backup_retention_days, local.is_production ? 30 : 7)
  log_retention_days = coalesce(var.log_retention_days, local.is_production ? 90 : 30)
  destroy_protection = coalesce(var.enable_destroy_protection, local.is_production)
  force_destroy      = coalesce(var.force_destroy_buckets, !local.is_production)
  price_class        = coalesce(var.cloudfront_price_class, local.is_production ? "PriceClass_All" : "PriceClass_100")

  common_tags = {
    Project     = var.project_name
    Environment = var.environment
    ManagedBy   = "terraform"
    Owner       = var.owner
  }

  frontend_bucket_name = "${local.name_prefix}-frontend-${random_id.suffix.hex}"
}

resource "random_id" "suffix" {
  byte_length = 4
}
