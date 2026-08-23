data "aws_iam_policy_document" "alerts_sns" {
  statement {
    sid    = "AllowAccountPublish"
    effect = "Allow"

    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${local.account_id}:root"]
    }

    actions   = ["sns:Publish", "sns:Subscribe", "sns:Receive"]
    resources = ["arn:${local.aws_partition}:sns:${local.aws_region}:${local.account_id}:${local.name_prefix}-alerts"]
  }

  statement {
    sid    = "AllowAwsServices"
    effect = "Allow"

    principals {
      type = "Service"
      identifiers = [
        "events.amazonaws.com",
        "budgets.amazonaws.com",
        "cloudwatch.amazonaws.com",
      ]
    }

    actions   = ["sns:Publish"]
    resources = ["arn:${local.aws_partition}:sns:${local.aws_region}:${local.account_id}:${local.name_prefix}-alerts"]
  }
}

resource "aws_sns_topic" "alerts" {
  name              = "${local.name_prefix}-alerts"
  kms_master_key_id = module.kms.key_arn
  policy            = data.aws_iam_policy_document.alerts_sns.json

  tags = { Name = "${local.name_prefix}-alerts" }
}

resource "aws_sns_topic_subscription" "email" {
  for_each = toset(var.approval_email_addresses)

  topic_arn = aws_sns_topic.alerts.arn
  protocol  = "email"
  endpoint  = each.value
}
