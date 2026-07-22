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
# Networking
#############################################

variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "public_subnet_ids" {
  description = "Public subnet IDs for the ALB"
  type        = list(string)
  validation {
    condition     = length(var.public_subnet_ids) >= 2
    error_message = "At least two public subnets are required for the ALB."
  }
}

#############################################
# Security
#############################################

variable "alb_security_group_id" {
  description = "Security Group ID for the Application Load Balancer"
  type        = string
}

#############################################
# Health Check Configuration
#############################################

variable "health_check_path" {
  description = "Health check path for the Target Group"
  type        = string
  default     = "/"
}

variable "health_check_protocol" {
  description = "Health check protocol"
  type        = string
  default     = "HTTP"
}

variable "health_check_port" {
  description = "Health check port"
  type        = string
  default     = "traffic-port"
}