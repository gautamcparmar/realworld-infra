output "artifacts_bucket" {
  description = "Release artifacts are stored as s3://bucket/<version>/frontend.zip and s3://bucket/<version>/backend.zip."
  value       = module.artifacts_bucket.id
}

output "artifacts_bucket_arn" {
  value = module.artifacts_bucket.arn
}

output "frontend_pipeline_name" {
  value = module.frontend_pipeline.pipeline_name
}

# output "backend_pipeline_name" {
#   value = module.backend_pipeline.pipeline_name
# }

output "frontend_codebuild_role_arn" {
  value = module.frontend_iam.codebuild_role_arn
}

# output "backend_codebuild_role_arn" {
#   value = module.backend_iam.codebuild_role_arn
# }

output "codestar_connection_arn" {
  value = local.codestar_connection_arn
}

output "codestar_connection_status_note" {
  value = var.codestar_connection_arn == "" ? "Authorize the GitHub connection in the AWS console before the first pipeline run." : "Using the supplied CodeStar connection."
}

output "ssm_parameter_prefix" {
  value = "/${var.project_name}/shared"
}
