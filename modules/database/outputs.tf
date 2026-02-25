# =============================================================================
# modules/database/outputs.tf
# Exposes database resource attributes to the root module.
# =============================================================================

output "db_endpoint" {
  description = "Connection endpoint for the RDS instance (hostname:port)."
  value       = aws_db_instance.main.endpoint
}

output "db_host" {
  description = "Hostname of the RDS instance (without port)."
  value       = aws_db_instance.main.address
}

output "db_port" {
  description = "Port the RDS instance is listening on."
  value       = aws_db_instance.main.port
}

output "db_name" {
  description = "Name of the initial database created in RDS."
  value       = aws_db_instance.main.db_name
}

output "db_identifier" {
  description = "Identifier (name) of the RDS instance."
  value       = aws_db_instance.main.identifier
}

output "db_arn" {
  description = "ARN of the RDS instance."
  value       = aws_db_instance.main.arn
}

output "db_security_group_id" {
  description = "ID of the security group attached to the RDS instance."
  value       = aws_security_group.db.id
}

output "db_subnet_group_name" {
  description = "Name of the DB subnet group."
  value       = aws_db_subnet_group.main.name
}
