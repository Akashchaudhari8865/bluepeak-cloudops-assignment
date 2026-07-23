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
# Database Configuration
#############################################

variable "db_name" {
  description = "Database name"
  type        = string
}

variable "db_username" {
  description = "Master username"
  type        = string
}

#############################################
# Networking
#############################################

variable "private_db_subnet_ids" {
  description = "Private database subnet IDs"
  type        = list(string)

  validation {
    condition     = length(var.private_db_subnet_ids) >= 2
    error_message = "At least two private DB subnets are required."
  }
}

#############################################
# Security
#############################################

variable "db_security_group_id" {
  description = "Security Group ID for RDS"
  type        = string
}

#############################################
# RDS Configuration
#############################################

variable "engine" {
  description = "Database engine"
  type        = string
  default     = "mysql"
}

variable "engine_version" {
  description = "Database engine version"
  type        = string
  default     = "8.0"
}

variable "instance_class" {
  description = "RDS instance class"
  type        = string
  default     = "db.t3.micro"
}

variable "allocated_storage" {
  description = "Allocated storage in GB"
  type        = number
  default     = 20
}

variable "storage_type" {
  description = "Storage type"
  type        = string
  default     = "gp3"
}

variable "multi_az" {
  description = "Enable Multi-AZ deployment"
  type        = bool
  default     = false
}

variable "publicly_accessible" {
  description = "Whether the database is publicly accessible"
  type        = bool
  default     = false
}


variable "backup_retention_period" {
  description = "Number of backup retention days"
  type        = number
  default     = 0
}

variable "skip_final_snapshot" {
  description = "Skip final snapshot when deleting the database"
  type        = bool
  default     = true
}

variable "multi_az" {
  description = "Enable Multi-AZ deployment for the RDS instance to provide high availability and automatic failover."
  type        = bool
  default     = false
}