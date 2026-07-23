#############################################
# AWS Configuration
#############################################

aws_region   = "us-east-1"
project_name = "cloudops"
environment  = "dev"

#############################################
# Networking
#############################################

vpc_cidr = "10.0.0.0/16"

availability_zones = [
  "us-east-1a",
  "us-east-1b"
]

public_subnet_cidrs = [
  "10.0.1.0/24",
  "10.0.2.0/24"
]

private_app_subnet_cidrs = [
  "10.0.11.0/24",
  "10.0.12.0/24"
]

private_db_subnet_cidrs = [
  "10.0.21.0/24",
  "10.0.22.0/24"
]

#############################################
# EC2
#############################################

instance_type = "t3.micro"

key_name = "CloudOps-Assignment-key"

#############################################
# Auto Scaling
#############################################

desired_capacity = 2

min_size = 2

max_size = 4

#############################################
# Database
#############################################

db_name = "counterdb"

db_username = "admin"
