data "aws_partition" "current" {}

data "aws_iam_policy_document" "backup_assume" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["backup.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "backup" {
  name               = "${var.name_prefix}-rds-backup"
  assume_role_policy = data.aws_iam_policy_document.backup_assume.json
  tags               = merge(var.tags, { Name = "${var.name_prefix}-rds-backup" })
}

resource "aws_iam_role_policy_attachment" "backup" {
  role       = aws_iam_role.backup.name
  policy_arn = "arn:${data.aws_partition.current.partition}:iam::aws:policy/service-role/AWSBackupServiceRolePolicyForBackup"
}

resource "aws_iam_role_policy_attachment" "restore" {
  role       = aws_iam_role.backup.name
  policy_arn = "arn:${data.aws_partition.current.partition}:iam::aws:policy/service-role/AWSBackupServiceRolePolicyForRestores"
}

resource "aws_backup_vault" "this" {
  name        = "${var.name_prefix}-rds"
  kms_key_arn = var.kms_key_arn
  tags        = merge(var.tags, { Name = "${var.name_prefix}-rds-backup" })
}

resource "aws_backup_plan" "this" {
  name = "${var.name_prefix}-rds-daily"
  tags = merge(var.tags, { Name = "${var.name_prefix}-rds-daily" })

  rule {
    rule_name         = "daily"
    target_vault_name = aws_backup_vault.this.name
    schedule          = var.backup_schedule
    start_window      = 60
    completion_window = 180

    lifecycle {
      delete_after = var.backup_retention_period
    }
  }
}

resource "aws_backup_selection" "this" {
  name         = "${var.name_prefix}-rds"
  iam_role_arn = aws_iam_role.backup.arn
  plan_id      = aws_backup_plan.this.id
  resources    = [aws_db_instance.this.arn]

  depends_on = [
    aws_iam_role_policy_attachment.backup,
    aws_iam_role_policy_attachment.restore,
  ]
}
