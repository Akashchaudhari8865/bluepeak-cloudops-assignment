#############################################
# Project Configuration
#############################################

variable "project_name" {
  description = "Project name"
  type        = string
}

variable "environment" {
  description = "Deployment environment"
  type        = string
}

#############################################
# VPC Configuration
#############################################

variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
}

#############################################
# Availability Zones
#############################################

variable "availability_zones" {
  description = "Availability Zones"
  type        = list(string)

  validation {
    condition     = length(var.availability_zones) == 2
    error_message = "Exactly two Availability Zones are required."
  }
}

#############################################
# Public Subnets
#############################################

variable "public_subnet_cidrs" {
  description = "CIDR blocks for public subnets"
  type        = list(string)

  validation {
    condition     = length(var.public_subnet_cidrs) == 2
    error_message = "Exactly two public subnet CIDRs are required."
  }
}

#############################################
# Private Application Subnets
#############################################

variable "private_app_subnet_cidrs" {
  description = "CIDR blocks for private application subnets"
  type        = list(string)

  validation {
    condition     = length(var.private_app_subnet_cidrs) == 2
    error_message = "Exactly two private application subnet CIDRs are required."
  }
}

#############################################
# Private Database Subnets
#############################################

variable "private_db_subnet_cidrs" {
  description = "CIDR blocks for private database subnets"
  type        = list(string)

  validation {
    condition     = length(var.private_db_subnet_cidrs) == 2
    error_message = "Exactly two private database subnet CIDRs are required."
  }
}