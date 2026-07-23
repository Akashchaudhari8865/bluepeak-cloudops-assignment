#############################################
# AWS Configuration
#############################################

variable "aws_region" {
  description = "AWS Region"
  type        = string
  default     = "us-east-1"
}

variable "project_name" {
  description = "Project Name"
  type        = string
  default     = "CloudOps-Assignment-project"
}

variable "environment" {
  description = "Deployment Environment"
  type        = string
  default     = "dev"
}

#############################################
# Networking
#############################################

variable "vpc_cidr" {
  description = "CIDR Block for VPC"
  type        = string
}

variable "availability_zones" {
  description = "Availability Zones"
  type        = list(string)
}

variable "public_subnet_cidrs" {
  description = "CIDRs for Public Subnets"
  type        = list(string)
}

variable "private_app_subnet_cidrs" {
  description = "CIDRs for Private Application Subnets"
  type        = list(string)
}

variable "private_db_subnet_cidrs" {
  description = "CIDRs for Private Database Subnets"
  type        = list(string)
}

#############################################
# EC2
#############################################

variable "instance_type" {
  description = "EC2 Instance Type"
  type        = string
}

variable "key_name" {
  description = "AWS Key Pair Name"
  type        = string
}

#############################################
# Database
#############################################

variable "db_name" {
  description = "Database Name"
  type        = string
}

variable "db_username" {
  description = "Database Username"
  type        = string
}

#############################################
# Auto Scaling
#############################################

variable "desired_capacity" {
  description = "Desired Capacity"
  type        = number
}

variable "min_size" {
  description = "Minimum EC2 Instances"
  type        = number
}

variable "max_size" {
  description = "Maximum EC2 Instances"
  type        = number
}