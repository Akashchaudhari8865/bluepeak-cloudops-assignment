#############################################
# VPC
#############################################

output "vpc_id" {
  description = "VPC ID"
  value       = aws_vpc.main.id
}

#############################################
# Internet Gateway
#############################################

output "internet_gateway_id" {
  description = "Internet Gateway ID"
  value       = aws_internet_gateway.main.id
}

#############################################
# Public Subnets
#############################################

output "public_subnet_ids" {
  description = "List of Public Subnet IDs"

  value = [
    aws_subnet.public_1.id,
    aws_subnet.public_2.id
  ]
}

#############################################
# Private Application Subnets
#############################################

output "private_app_subnet_ids" {
  description = "List of Private Application Subnet IDs"

  value = [
    aws_subnet.private_app_1.id,
    aws_subnet.private_app_2.id
  ]
}

#############################################
# Private Database Subnets
#############################################

output "private_db_subnet_ids" {
  description = "List of Private Database Subnet IDs"

  value = [
    aws_subnet.private_db_1.id,
    aws_subnet.private_db_2.id
  ]
}

#############################################
# NAT Gateway
#############################################

output "nat_gateway_id" {
  description = "NAT Gateway ID"
  value       = aws_nat_gateway.main.id
}

#############################################
# Elastic IP
#############################################

output "nat_eip" {
  description = "Elastic IP associated with NAT Gateway"
  value       = aws_eip.nat.public_ip
}

#############################################
# Route Tables
#############################################

output "public_route_table_id" {
  description = "Public Route Table ID"
  value       = aws_route_table.public.id
}

output "private_route_table_id" {
  description = "Private Route Table ID"
  value       = aws_route_table.private.id
}