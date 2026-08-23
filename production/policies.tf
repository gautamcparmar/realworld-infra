data "aws_iam_policy_document" "frontend_bucket" {
  source_policy_documents = [module.cloudfront.frontend_bucket_policy_json]

  statement {
    sid    = "AllowSharedFrontendCodeBuild"
    effect = "Allow"

    principals {
      type        = "AWS"
      identifiers = [data.aws_ssm_parameter.frontend_codebuild_role_arn.value]
    }

    actions = [
      "s3:GetObject",
      "s3:GetObjectVersion",
      "s3:PutObject",
      "s3:DeleteObject",
      "s3:ListBucket",
    ]

    resources = [
      "arn:${local.aws_partition}:s3:::${local.frontend_bucket_name}",
      "arn:${local.aws_partition}:s3:::${local.frontend_bucket_name}/*",
    ]
  }
}
