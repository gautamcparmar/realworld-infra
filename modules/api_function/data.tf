data "archive_file" "placeholder" {
  type        = "zip"
  source_file = "${path.module}/src/index.js"
  output_path = "${path.module}/.build/placeholder.zip"
}

data "aws_iam_policy_document" "assume" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "lambda" {
  name               = "${local.function_name}-fn"
  assume_role_policy = data.aws_iam_policy_document.assume.json
  tags               = merge(var.tags, { Name = "${local.function_name}-fn" })
}

data "aws_iam_policy_document" "lambda" {
  statement {
    sid       = "Kms"
    effect    = "Allow"
    actions   = ["kms:Encrypt", "kms:Decrypt", "kms:DescribeKey", "kms:GenerateDataKey*", "kms:CreateGrant"]
    resources = [var.kms_key_arn]
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
      "arn:${var.aws_partition}:ssm:${var.aws_region}:${var.aws_account_id}:parameter${var.ssm_parameter_prefix}/*",
    ]
  }

  dynamic "statement" {
    for_each = var.db_secret_arn == null ? [
      aws_secretsmanager_secret.this.arn
    ] : [
      var.db_secret_arn,
      aws_secretsmanager_secret.this.arn
    ]

    content {
      effect = "Allow"
      actions = [
        "secretsmanager:GetSecretValue",
        "secretsmanager:DescribeSecret",
      ]
      resources = [statement.value]
    }
  }
}