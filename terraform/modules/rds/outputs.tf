#############################################
# RDS Instance
#############################################

output "db_instance_id" {
  description = "RDS Instance ID"
  value       = aws_db_instance.main.id
}

output "db_instance_arn" {
  description = "RDS Instance ARN"
  value       = aws_db_instance.main.arn
}

output "db_instance_identifier" {
  description = "RDS Instance Identifier"
  value       = aws_db_instance.main.identifier
}

#############################################
# Database Endpoint
#############################################

output "db_endpoint" {
  description = "RDS Endpoint"
  value       = aws_db_instance.main.endpoint
}

output "db_address" {
  description = "RDS Address"
  value       = aws_db_instance.main.address
}

output "db_port" {
  description = "Database Port"
  value       = aws_db_instance.main.port
}

#############################################
# Database Information
#############################################

output "db_name" {
  description = "Database Name"
  value       = aws_db_instance.main.db_name
}

output "db_engine" {
  description = "Database Engine"
  value       = aws_db_instance.main.engine
}

output "db_engine_version" {
  description = "Database Engine Version"
  value       = aws_db_instance.main.engine_version
}

#############################################
# DB Subnet Group
#############################################

output "db_subnet_group_name" {
  description = "DB Subnet Group Name"
  value       = aws_db_subnet_group.main.name
}

output "master_user_secret_arn" {
  description = "Secrets Manager ARN"

  value = aws_db_instance.main.master_user_secret[0].secret_arn
}