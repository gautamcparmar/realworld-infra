data "aws_iam_policy_document" "artifacts_bucket" {
  statement {
    sid    = "PipelineRoles"
    effect = "Allow"

    principals {
      type = "AWS"
      identifiers = [
        module.frontend_iam.codepipeline_role_arn,
        module.frontend_iam.codebuild_role_arn,
        # module.backend_iam.codepipeline_role_arn,
        # module.backend_iam.codebuild_role_arn,
      ]
    }

    actions = [
      "s3:GetObject",
      "s3:GetObjectVersion",
      "s3:PutObject",
      "s3:AbortMultipartUpload",
      "s3:ListMultipartUploadParts",
    ]

    resources = ["arn:${local.aws_partition}:s3:::${local.artifacts_bucket_name}/*"]
  }

  statement {
    sid    = "PipelineListBucket"
    effect = "Allow"

    principals {
      type = "AWS"
      identifiers = [
        module.frontend_iam.codepipeline_role_arn,
        module.frontend_iam.codebuild_role_arn,
        # module.backend_iam.codepipeline_role_arn,
        # module.backend_iam.codebuild_role_arn,
      ]
    }

    actions   = ["s3:ListBucket", "s3:GetBucketLocation", "s3:GetBucketVersioning"]
    resources = ["arn:${local.aws_partition}:s3:::${local.artifacts_bucket_name}"]
  }
}
