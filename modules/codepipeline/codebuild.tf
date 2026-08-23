resource "aws_cloudwatch_log_group" "codebuild" {
  for_each = local.build_projects

  name              = "/aws/codebuild/${local.pipeline_name}-${each.key}"
  retention_in_days = var.log_retention_days
  kms_key_id        = var.kms_key_arn
}

resource "aws_codebuild_project" "stage" {
  for_each = local.build_projects

  name                   = "${local.pipeline_name}-${each.key}"
  description            = "${title(each.key)} stage for the ${var.component} pipeline"
  service_role           = var.codebuild_role_arn
  build_timeout          = each.value.timeout
  queued_timeout         = 30
  encryption_key         = var.kms_key_arn
  concurrent_build_limit = 1

  artifacts {
    type = "CODEPIPELINE"
  }

  cache {
    type     = "S3"
    location = "${var.artifacts_bucket_name}/codebuild-cache/${var.component}/${each.key}"
  }

  environment {
    compute_type                = var.codebuild_compute_type
    image                       = var.codebuild_image
    type                        = "LINUX_CONTAINER"
    image_pull_credentials_type = "CODEBUILD"
    privileged_mode             = var.privileged_mode

    environment_variable {
      name  = "ENVIRONMENT"
      value = "stage"
    }

    environment_variable {
      name  = "AWS_ACCOUNT_ID"
      value = var.aws_account_id
    }

    environment_variable {
      name  = "AWS_PARTITION"
      value = var.aws_partition
    }

    environment_variable {
      name  = "AWS_DEFAULT_REGION"
      value = var.aws_region
    }

    environment_variable {
      name  = "PROJECT_NAME"
      value = var.project_name
    }

    environment_variable {
      name  = "COMPONENT"
      value = var.component
    }

    environment_variable {
      name  = "ARTIFACTS_BUCKET"
      value = var.artifacts_bucket_name
    }

    environment_variable {
      name  = "ARTIFACTS_KMS_KEY_ARN"
      value = var.kms_key_arn
    }

    environment_variable {
      name  = "ARTIFACT_OBJECT_KEY_TEMPLATE"
      value = "<version>/${local.artifact_zip}"
    }

    environment_variable {
      name  = "ARTIFACT_ZIP_NAME"
      value = local.artifact_zip
    }

    environment_variable {
      name  = "PIPELINE_STAGE"
      value = each.key
    }

    dynamic "environment_variable" {
      for_each = var.environment_variables

      content {
        name  = environment_variable.key
        value = environment_variable.value
      }
    }
  }

  logs_config {
    cloudwatch_logs {
      group_name = aws_cloudwatch_log_group.codebuild[each.key].name
    }
  }

  source {
    type      = "CODEPIPELINE"
    buildspec = each.value.buildspec
  }

  dynamic "vpc_config" {
    for_each = var.vpc_config != null ? [var.vpc_config] : []

    content {
      vpc_id             = vpc_config.value.vpc_id
      subnets            = vpc_config.value.subnets
      security_group_ids = vpc_config.value.security_group_ids
    }
  }

  tags = merge(var.tags, { Name = "${local.pipeline_name}-${each.key}" })
}
