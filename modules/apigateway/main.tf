resource "aws_apigatewayv2_api" "this" {
  name          = "${var.name_prefix}-http"
  protocol_type = "HTTP"
  description   = "HTTP API owned by Terraform. The api_function module attaches the Lambda integration."

  cors_configuration {
    allow_credentials = false
    allow_headers     = ["authorization", "content-type", "x-requested-with"]
    allow_methods     = ["GET", "POST", "PUT", "PATCH", "DELETE", "OPTIONS"]
    allow_origins     = var.cors_allow_origins
    max_age           = 300
  }

  tags = merge(var.tags, { Name = "${var.name_prefix}-http-api" })
}

resource "aws_cloudwatch_log_group" "access" {
  name              = "/aws/apigateway/${var.name_prefix}/access"
  retention_in_days = var.log_retention_days
  kms_key_id        = var.kms_key_arn

  tags = merge(var.tags, { Name = "${var.name_prefix}-api-access-logs" })
}

resource "aws_cloudwatch_log_group" "execution" {
  name              = "/aws/apigateway/${var.name_prefix}/execution"
  retention_in_days = var.log_retention_days
  kms_key_id        = var.kms_key_arn

  tags = merge(var.tags, { Name = "${var.name_prefix}-api-execution-logs" })
}

resource "aws_apigatewayv2_stage" "default" {
  api_id      = aws_apigatewayv2_api.this.id
  name        = "$default"
  auto_deploy = true

  default_route_settings {
    throttling_burst_limit   = var.throttling_burst_limit
    throttling_rate_limit    = var.throttling_rate_limit
    detailed_metrics_enabled = true
  }

  access_log_settings {
    destination_arn = aws_cloudwatch_log_group.access.arn
    format = jsonencode({
      requestId          = "$context.requestId"
      ip                 = "$context.identity.sourceIp"
      requestTime        = "$context.requestTime"
      httpMethod         = "$context.httpMethod"
      routeKey           = "$context.routeKey"
      status             = "$context.status"
      protocol           = "$context.protocol"
      responseLength     = "$context.responseLength"
      integrationStatus  = "$context.integrationStatus"
      integrationLatency = "$context.integrationLatency"
      error              = "$context.error.message"
    })
  }

  tags = merge(var.tags, { Name = "${var.name_prefix}-http-default" })
}
