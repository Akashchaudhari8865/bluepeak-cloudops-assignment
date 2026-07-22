#############################################
# Networking
#############################################

output "vpc_id" {
  description = "VPC ID"
  value       = module.networking.vpc_id
}

output "public_subnet_ids" {
  description = "Public Subnet IDs"
  value       = module.networking.public_subnet_ids
}

output "private_app_subnet_ids" {
  description = "Private Application Subnet IDs"
  value       = module.networking.private_app_subnet_ids
}

output "private_db_subnet_ids" {
  description = "Private Database Subnet IDs"
  value       = module.networking.private_db_subnet_ids
}

#############################################
# Load Balancer
#############################################

output "alb_dns_name" {
  description = "Application Load Balancer DNS"
  value       = module.alb.alb_dns_name
}

#############################################
# EC2
#############################################

output "launch_template_id" {
  description = "Launch Template ID"
  value       = module.ec2.launch_template_id
}

#############################################
# Auto Scaling
#############################################

output "autoscaling_group_name" {
  description = "Auto Scaling Group Name"
  value       = module.autoscaling.autoscaling_group_name
}

#############################################
# Database
#############################################

output "rds_endpoint" {
  description = "RDS Endpoint"
  value       = module.rds.db_endpoint
  sensitive   = true
}

output "rds_secret_arn" {
  description = "Secrets Manager ARN"

  value = module.rds.master_user_secret_arn
}