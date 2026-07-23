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
# Auto Scaling Configuration
#############################################

variable "desired_capacity" {
  description = "The desired number of instances in the Auto Scaling group"
  type        = number
  default     = 2

  validation {
    condition     = var.desired_capacity >= var.min_size && var.desired_capacity <= var.max_size
    error_message = "Desired capacity must be between min_size and max_size."
  }
}

variable "min_size" {
  description = "The minimum number of instances in the Auto Scaling group"
  type        = number
  default     = 2

  validation {
    condition     = var.min_size >= 0 && var.min_size <= var.max_size
    error_message = "min_size must be non-negative and no greater than max_size."
  }
}

variable "max_size" {
  description = "The maximum number of instances in the Auto Scaling group"
  type        = number
  default     = 4

  validation {
    condition     = var.max_size >= 1
    error_message = "max_size must be at least 1."
  }
}

variable "private_subnet_ids" {
  description = "Private subnet IDs in which the Auto Scaling group launches instances"
  type        = list(string)

  validation {
    condition     = length(var.private_subnet_ids) >= 2
    error_message = "At least two private subnets are required."
  }
}

variable "launch_template_id" {
  description = "ID of the launch template used by the Auto Scaling group"
  type        = string
}

variable "target_group_arn" {
  description = "ARN of the ALB target group attached to the Auto Scaling group"
  type        = string
}

variable "health_check_grace_period" {
  description = "Seconds to wait before checking the health of a newly launched instance"
  type        = number
  default     = 300
}

variable "instance_warmup" {
  description = "Seconds to wait before considering a refreshed instance warm"
  type        = number
  default     = 300
}

variable "cpu_target_value" {
  description = "Target average CPU utilization (%) the scaling policy tries to maintain across the ASG"
  type        = number
  default     = 60
}
