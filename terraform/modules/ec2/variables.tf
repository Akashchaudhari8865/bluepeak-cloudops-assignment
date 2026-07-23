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

variable "private_app_subnet_ids" {
  description = "Private application subnet IDs"
  type        = list(string)

  validation {
    condition     = length(var.private_app_subnet_ids) >= 2
    error_message = "At least two private application subnets are required."
  }
}

#############################################
# Security
#############################################

variable "ec2_security_group_id" {
  description = "EC2 Security Group ID"
  type        = string
}

#############################################
# EC2 Configuration
#############################################

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"
}

variable "key_name" {
  description = "EC2 Key Pair name"
  type        = string
}

#############################################
# Storage
#############################################

variable "root_volume_size" {
  description = "Root EBS volume size (GB)"
  type        = number
  default     = 30
}

variable "root_volume_type" {
  description = "Root EBS volume type"
  type        = string
  default     = "gp3"
}

#############################################
# IAM
#############################################

variable "iam_role_name" {
  description = "IAM Role name"
  type        = string
  default     = "ec2-role"
}

#############################################
# Application
#############################################

variable "app_name" {
  description = "Application name"
  type        = string
  default     = "counter-app"
}


variable "artifact_bucket_name" {
  description = "S3 bucket containing application artifacts"
  type        = string
}

variable "artifact_object_key" {
  description = "S3 object key for the application zip"
  type        = string
  default     = "application.zip"
}

variable "app_version" {
  description = "Application version/hash used to trigger Launch Template updates"
  type        = string
}