resource "aws_security_group" "lambda" {
  name        = "${var.name_prefix}-lambda"
  description = "Lambda functions in application subnets"
  vpc_id      = var.vpc_id

  tags = merge(var.tags, { Name = "${var.name_prefix}-lambda-sg" })
}

resource "aws_vpc_security_group_egress_rule" "lambda_https" {
  security_group_id = aws_security_group.lambda.id
  description       = "HTTPS via NAT to AWS APIs and the internet"
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 443
  to_port           = 443
  ip_protocol       = "tcp"
}

resource "aws_vpc_security_group_egress_rule" "lambda_postgres" {
  security_group_id            = aws_security_group.lambda.id
  description                  = "PostgreSQL to RDS"
  referenced_security_group_id = aws_security_group.rds.id
  from_port                    = var.rds_port
  to_port                      = var.rds_port
  ip_protocol                  = "tcp"
}

resource "aws_security_group" "rds" {
  name        = "${var.name_prefix}-rds"
  description = "PostgreSQL only from Lambda"
  vpc_id      = var.vpc_id

  tags = merge(var.tags, { Name = "${var.name_prefix}-rds-sg" })
}

resource "aws_vpc_security_group_ingress_rule" "rds_from_lambda" {
  security_group_id            = aws_security_group.rds.id
  description                  = "PostgreSQL from Lambda"
  referenced_security_group_id = aws_security_group.lambda.id
  from_port                    = var.rds_port
  to_port                      = var.rds_port
  ip_protocol                  = "tcp"
}

resource "aws_vpc_security_group_ingress_rule" "rds_from_cidr" {
  for_each = toset(var.rds_allowed_cidr_blocks)

  security_group_id = aws_security_group.rds.id
  description       = "Break-glass PostgreSQL from named CIDR"
  cidr_ipv4         = each.value
  from_port         = var.rds_port
  to_port           = var.rds_port
  ip_protocol       = "tcp"
}
