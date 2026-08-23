data "aws_iam_policy_document" "codepipeline_assume" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["codepipeline.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "codepipeline" {
  name               = "${local.pipeline_name}-pipeline"
  assume_role_policy = data.aws_iam_policy_document.codepipeline_assume.json
  tags               = merge(var.tags, { Name = "${local.pipeline_name}-pipeline" })
}

data "aws_iam_policy_document" "codepipeline" {
  statement {
    sid    = "ArtifactsBucket"
    effect = "Allow"
    actions = [
      "s3:GetObject",
      "s3:GetObjectVersion",
      "s3:PutObject",
      "s3:PutObjectAcl",
    ]
    resources = [
      "${var.artifacts_bucket_arn}/*",
    ]
  }

  statement {
    sid       = "ListArtifactsBucket"
    effect    = "Allow"
    actions   = ["s3:ListBucket", "s3:GetBucketLocation"]
    resources = [var.artifacts_bucket_arn]
  }

  statement {
    sid       = "StartCodeBuild"
    effect    = "Allow"
    actions   = ["codebuild:StartBuild", "codebuild:BatchGetBuilds"]
    resources = [local.codebuild_project_arn]
  }

  statement {
    sid    = "UseCodeStarConnection"
    effect = "Allow"
    actions = [
      "codestar-connections:UseConnection",
      "codeconnections:UseConnection",
    ]
    resources = [
      var.codestar_connection_arn,
      replace(var.codestar_connection_arn, ":codestar-connections:", ":codeconnections:"),
    ]
  }

  statement {
    sid       = "Kms"
    effect    = "Allow"
    actions   = ["kms:Decrypt", "kms:DescribeKey", "kms:Encrypt", "kms:GenerateDataKey*"]
    resources = [var.kms_key_arn]
  }

  statement {
    sid       = "NotifyApprovers"
    effect    = "Allow"
    actions   = ["sns:Publish"]
    resources = [var.approval_sns_topic_arn]
  }

  dynamic "statement" {
    for_each = var.component == "backend" ? [1] : []

    content {
      sid    = "StartCodeDeploy"
      effect = "Allow"
      actions = [
        "codedeploy:CreateDeployment",
        "codedeploy:GetApplication",
        "codedeploy:GetApplicationRevision",
        "codedeploy:GetDeployment",
        "codedeploy:GetDeploymentConfig",
        "codedeploy:GetDeploymentGroup",
        "codedeploy:RegisterApplicationRevision",
      ]
      resources = [
        "arn:${var.aws_partition}:codedeploy:${var.aws_region}:${var.aws_account_id}:application:${var.project_name}-*-api",
        "arn:${var.aws_partition}:codedeploy:${var.aws_region}:${var.aws_account_id}:deploymentgroup:${var.project_name}-*-api/*",
        "arn:${var.aws_partition}:codedeploy:${var.aws_region}:${var.aws_account_id}:deploymentconfig:*",
      ]
    }
  }
}

resource "aws_iam_role_policy" "codepipeline" {
  name   = "pipeline-access"
  role   = aws_iam_role.codepipeline.id
  policy = data.aws_iam_policy_document.codepipeline.json
}

data "aws_iam_policy_document" "codebuild_assume" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["codebuild.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "codebuild" {
  name               = "${local.pipeline_name}-codebuild"
  assume_role_policy = data.aws_iam_policy_document.codebuild_assume.json
  tags               = merge(var.tags, { Name = "${local.pipeline_name}-codebuild" })
}

data "aws_iam_policy_document" "codebuild" {
  statement {
    sid    = "Logs"
    effect = "Allow"
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
    ]
    resources = [
      "arn:${var.aws_partition}:logs:${var.aws_region}:${var.aws_account_id}:log-group:/aws/codebuild/${local.pipeline_name}-*",
    ]
  }

  statement {
    sid    = "Artifacts"
    effect = "Allow"
    actions = [
      "s3:GetObject",
      "s3:GetObjectVersion",
      "s3:PutObject",
      "s3:AbortMultipartUpload",
    ]
    resources = [
      "${var.artifacts_bucket_arn}/*",
    ]
  }

  statement {
    sid       = "ListArtifacts"
    effect    = "Allow"
    actions   = ["s3:ListBucket", "s3:GetBucketVersioning"]
    resources = [var.artifacts_bucket_arn]
  }

  statement {
    sid    = "Kms"
    effect = "Allow"
    actions = [
      "kms:Decrypt",
      "kms:DescribeKey",
      "kms:Encrypt",
      "kms:GenerateDataKey*",
    ]
    resources = [
      var.kms_key_arn,
      "arn:${var.aws_partition}:kms:${var.aws_region}:${var.aws_account_id}:key/*",
    ]
  }

  statement {
    sid    = "VpcEni"
    effect = "Allow"
    actions = [
      "ec2:CreateNetworkInterface",
      "ec2:DescribeNetworkInterfaces",
      "ec2:DeleteNetworkInterface",
      "ec2:DescribeSubnets",
      "ec2:DescribeSecurityGroups",
      "ec2:DescribeDhcpOptions",
      "ec2:DescribeVpcs",
      "ec2:CreateNetworkInterfacePermission",
    ]
    resources = ["*"]
  }

  statement {
    sid    = "ReadSsm"
    effect = "Allow"
    actions = [
      "ssm:GetParameter",
      "ssm:GetParameters",
      "ssm:GetParametersByPath",
    ]
    resources = [
      "arn:${var.aws_partition}:ssm:${var.aws_region}:${var.aws_account_id}:parameter/${var.project_name}/*",
    ]
  }

  dynamic "statement" {
    for_each = var.component == "frontend" ? [1] : []

    content {
      sid    = "DeployStaticSite"
      effect = "Allow"
      actions = [
        "s3:GetObject",
        "s3:GetObjectVersion",
        "s3:PutObject",
        "s3:DeleteObject",
        "s3:ListBucket",
        "s3:GetBucketLocation",
      ]
      resources = [
        "arn:${var.aws_partition}:s3:::${var.project_name}-*-frontend-*",
        "arn:${var.aws_partition}:s3:::${var.project_name}-*-frontend-*/*",
      ]
    }
  }

  dynamic "statement" {
    for_each = var.component == "frontend" ? [1] : []

    content {
      sid    = "ManageCloudFront"
      effect = "Allow"
      actions = [
        "cloudfront:GetDistribution",
        "cloudfront:GetDistributionConfig",
        "cloudfront:UpdateDistribution",
        "cloudfront:CreateInvalidation",
        "cloudfront:GetInvalidation",
      ]
      resources = ["arn:${var.aws_partition}:cloudfront::${var.aws_account_id}:distribution/*"]
    }
  }

  dynamic "statement" {
    for_each = var.component == "backend" ? [1] : []

    content {
      sid    = "UpdateApiFunction"
      effect = "Allow"
      actions = [
        "lambda:GetFunction",
        "lambda:GetFunctionConfiguration",
        "lambda:GetAlias",
        "lambda:ListVersionsByFunction",
        "lambda:UpdateFunctionCode",
        "lambda:PublishVersion",
      ]
      resources = [
        "arn:${var.aws_partition}:lambda:${var.aws_region}:${var.aws_account_id}:function:${var.project_name}-*-api",
        "arn:${var.aws_partition}:lambda:${var.aws_region}:${var.aws_account_id}:function:${var.project_name}-*-api:*",
      ]
    }
  }

  dynamic "statement" {
    for_each = var.component == "backend" ? [1] : []

    content {
      sid    = "DeployApiFunction"
      effect = "Allow"
      actions = [
        "codedeploy:CreateDeployment",
        "codedeploy:GetApplication",
        "codedeploy:GetApplicationRevision",
        "codedeploy:GetDeployment",
        "codedeploy:GetDeploymentConfig",
        "codedeploy:GetDeploymentGroup",
        "codedeploy:RegisterApplicationRevision",
      ]
      resources = [
        "arn:${var.aws_partition}:codedeploy:${var.aws_region}:${var.aws_account_id}:application:${var.project_name}-*-api",
        "arn:${var.aws_partition}:codedeploy:${var.aws_region}:${var.aws_account_id}:deploymentgroup:${var.project_name}-*-api/*",
        "arn:${var.aws_partition}:codedeploy:${var.aws_region}:${var.aws_account_id}:deploymentconfig:*",
      ]
    }
  }

}

resource "aws_iam_role_policy" "codebuild" {
  name   = "codebuild-access"
  role   = aws_iam_role.codebuild.id
  policy = data.aws_iam_policy_document.codebuild.json
}
