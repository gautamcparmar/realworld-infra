resource "aws_codestarconnections_connection" "github" {
  count = var.codestar_connection_arn == "" ? 1 : 0

  name          = "${var.project_name}-github"
  provider_type = var.codestar_provider_type

  tags = { Name = "${var.project_name}-github" }
}
