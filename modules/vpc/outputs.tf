output "vpc_id" {
  description = "VPC ID."
  value       = aws_vpc.this.id
}

output "vpc_cidr" {
  description = "VPC CIDR block."
  value       = aws_vpc.this.cidr_block
}

output "public_subnet_ids" {
  description = "Public subnet IDs (NAT and internet gateway)."
  value       = aws_subnet.public[*].id
}

output "application_subnet_ids" {
  description = "Application (private) subnet IDs used by Lambda."
  value       = aws_subnet.application[*].id
}

output "database_subnet_ids" {
  description = "Isolated database subnet IDs."
  value       = aws_subnet.database[*].id
}

# output "nat_gateway_ids" {
#   description = "NAT gateway IDs, one per availability zone."
#   value       = aws_nat_gateway.this[*].id
# }
