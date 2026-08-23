output "endpoint" {
  description = "RDS hostname."
  value       = aws_db_instance.this.address
}

output "port" {
  description = "RDS port."
  value       = aws_db_instance.this.port
}

output "instance_id" {
  description = "DB instance identifier."
  value       = aws_db_instance.this.id
}

output "master_user_secret_arn" {
  description = "Secrets Manager ARN for the generated master password."
  value       = aws_db_instance.this.master_user_secret[0].secret_arn
}

output "db_name" {
  description = "Initial database name."
  value       = aws_db_instance.this.db_name
}
