locals {
  pipeline_name = "${var.project_name}-${var.component}"
  artifact_zip  = var.component == "frontend" ? "frontend.zip" : "backend.zip"
  build_projects = {
    validate = {
      buildspec = var.buildspec_validate
      timeout   = 15
    }
    build = {
      buildspec = var.buildspec_build
      timeout   = 30
    }
    test = {
      buildspec = var.buildspec_test
      timeout   = 30
    }
    deploy = {
      buildspec = var.buildspec_deploy
      timeout   = 60
    }
  }

  pipeline_exec_id_env = {
    name  = "PIPELINE_EXEC_ID"
    type  = "PLAINTEXT"
    value = "#{codepipeline.PipelineExecutionId}"
  }
}
