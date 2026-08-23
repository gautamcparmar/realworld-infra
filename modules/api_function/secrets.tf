data "aws_iam_policy_document" "db_secret" {
  count = var.db_secret_arn == null ? 0 : 1

  statement {
    sid    = "AllowRdsManageSecret"
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["rds.amazonaws.com"]
    }

    actions = [
      "secretsmanager:GetSecretValue",
      "secretsmanager:DescribeSecret",
      "secretsmanager:PutSecretValue",
      "secretsmanager:DeleteSecret",
    ]
    resources = ["*"]

    condition {
      test     = "StringEquals"
      variable = "aws:SourceAccount"
      values   = [var.aws_account_id]
    }

    condition {
      test     = "ArnLike"
      variable = "aws:SourceArn"
      values   = ["arn:${var.aws_partition}:rds:${var.aws_region}:${var.aws_account_id}:db:*"]
    }
  }

  statement {
    sid    = "AllowApiFunctionRead"
    effect = "Allow"

    principals {
      type        = "AWS"
      identifiers = [aws_iam_role.lambda.arn]
    }

    actions = [
      "secretsmanager:GetSecretValue",
      "secretsmanager:DescribeSecret",
    ]
    resources = ["*"]
  }
}

resource "aws_secretsmanager_secret_policy" "db" {
  count = var.db_secret_arn == null ? 0 : 1

  secret_arn = var.db_secret_arn
  policy     = data.aws_iam_policy_document.db_secret[0].json
}

resource "aws_secretsmanager_secret" "this" {
  name = "${var.name_prefix}-api-function-secret"
  kms_key_id = var.kms_key_arn
  description = "Secret for the API function"
  recovery_window_in_days = 0
  tags = var.tags
}

resource "aws_secretsmanager_secret_version" "this" {
  secret_id = aws_secretsmanager_secret.this.id
  secret_string = jsonencode(var.environment_variables)
}