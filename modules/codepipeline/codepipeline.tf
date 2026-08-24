resource "aws_codepipeline" "this" {
  name           = local.pipeline_name
  pipeline_type  = "V2"
  role_arn       = var.codepipeline_role_arn
  execution_mode = "QUEUED"

  artifact_store {
    location = var.artifacts_bucket_name
    type     = "S3"

    encryption_key {
      id   = var.kms_key_arn
      type = "KMS"
    }
  }

  stage {
    name = "Source"

    action {
      name             = "Source"
      category         = "Source"
      owner            = "AWS"
      provider         = "CodeStarSourceConnection"
      version          = "1"
      output_artifacts = ["source_output"]
      namespace        = "SourceVariables"

      configuration = {
        ConnectionArn        = var.codestar_connection_arn
        FullRepositoryId     = var.repository_id
        BranchName           = var.source_branch
        DetectChanges        = "true"
        OutputArtifactFormat = "CODE_ZIP"
      }
    }
  }

  stage {
    name = "Validate"

    action {
      name            = "Validate"
      category        = "Build"
      owner           = "AWS"
      provider        = "CodeBuild"
      version         = "1"
      input_artifacts = ["source_output"]

      configuration = {
        ProjectName = aws_codebuild_project.stage["validate"].name
        EnvironmentVariables = jsonencode([
          local.pipeline_exec_id_env,
        ])
      }
    }
  }

  stage {
    name = "Build"

    action {
      name             = "Build"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      version          = "1"
      input_artifacts  = ["source_output"]
      output_artifacts = ["build_output"]

      configuration = {
        ProjectName = aws_codebuild_project.stage["build"].name
        EnvironmentVariables = jsonencode([
          local.pipeline_exec_id_env,
          {
            name  = "SOURCE_VERSION"
            type  = "PLAINTEXT"
            value = "#{SourceVariables.CommitId}"
          }
        ])
      }
    }
  }

  stage {
    name = "Test"

    action {
      name            = "Test"
      category        = "Build"
      owner           = "AWS"
      provider        = "CodeBuild"
      version         = "1"
      input_artifacts = ["source_output", "build_output"]

      configuration = {
        ProjectName   = aws_codebuild_project.stage["test"].name
        PrimarySource = "source_output"
        EnvironmentVariables = jsonencode([
          local.pipeline_exec_id_env,
        ])
      }
    }
  }

  stage {
    name = "Deploy-Stage"

    action {
      name            = "DeployStage"
      category        = "Build"
      owner           = "AWS"
      provider        = "CodeBuild"
      version         = "1"
      input_artifacts = ["source_output", "build_output"]

      configuration = {
        ProjectName   = aws_codebuild_project.stage["deploy"].name
        PrimarySource = "source_output"
        EnvironmentVariables = jsonencode([
          local.pipeline_exec_id_env,
          {
            name  = "SOURCE_VERSION"
            type  = "PLAINTEXT"
            value = "#{SourceVariables.CommitId}"
          },
          {
            name  = "ENVIRONMENT"
            type  = "PLAINTEXT"
            value = "stage"
          }
        ])
      }
    }
  }

  dynamic "stage" {
    for_each = local.enable_perf_test ? [1] : []

    content {
      name = "Performance-Test"

      action {
        name            = "PerformanceTest"
        category        = "Build"
        owner           = "AWS"
        provider        = "CodeBuild"
        version         = "1"
        input_artifacts = ["source_output"]

        configuration = {
          ProjectName = aws_codebuild_project.stage["perf_test"].name
          EnvironmentVariables = jsonencode([
            local.pipeline_exec_id_env,
            {
              name  = "ENVIRONMENT"
              type  = "PLAINTEXT"
              value = "stage"
            }
          ])
        }
      }
    }
  }

  dynamic "stage" {
    for_each = var.require_production_approval ? [1] : []

    content {
      name = "Approval"

      action {
        name     = "ProductionApproval"
        category = "Approval"
        owner    = "AWS"
        provider = "Manual"
        version  = "1"

        configuration = {
          NotificationArn    = var.approval_sns_topic_arn
          CustomData         = "Approve ${var.component} deployment to production."
          ExternalEntityLink = "https://console.aws.amazon.com/codesuite/codepipeline/pipelines/${local.pipeline_name}/view"
        }
      }
    }
  }

  stage {
    name = "Deploy-Production"

    action {
      name            = "DeployProduction"
      category        = "Build"
      owner           = "AWS"
      provider        = "CodeBuild"
      version         = "1"
      input_artifacts = ["source_output", "build_output"]

      configuration = {
        ProjectName   = aws_codebuild_project.stage["deploy"].name
        PrimarySource = "source_output"
        EnvironmentVariables = jsonencode([
          local.pipeline_exec_id_env,
          {
            name  = "SOURCE_VERSION"
            type  = "PLAINTEXT"
            value = "#{SourceVariables.CommitId}"
          },
          {
            name  = "ENVIRONMENT"
            type  = "PLAINTEXT"
            value = "production"
          }
        ])
      }
    }
  }

  tags = merge(var.tags, { Name = local.pipeline_name })

  lifecycle {
    ignore_changes = [trigger]
  }
}

resource "aws_codestarnotifications_notification_rule" "this" {
  name        = "${local.pipeline_name}-events"
  detail_type = "FULL"
  resource    = aws_codepipeline.this.arn

  event_type_ids = [
    "codepipeline-pipeline-pipeline-execution-failed",
    "codepipeline-pipeline-pipeline-execution-succeeded",
    "codepipeline-pipeline-manual-approval-needed",
    "codepipeline-pipeline-manual-approval-failed",
  ]

  target {
    address = var.approval_sns_topic_arn
    type    = "SNS"
  }
}
