output "s3_origin_id" {
  value = "s3-frontend"
}

output "distribution_id" {
  value = aws_cloudfront_distribution.this.id
}

output "distribution_arn" {
  value = aws_cloudfront_distribution.this.arn
}

output "domain_name" {
  value = aws_cloudfront_distribution.this.domain_name
}

output "frontend_bucket_policy_json" {
  description = "S3 bucket policy statement that allows this distribution to read via OAC."
  value       = data.aws_iam_policy_document.frontend_oac.json
}
