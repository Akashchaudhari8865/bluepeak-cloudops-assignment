#############################################
# Launch Template Outputs
#############################################

output "launch_template_id" {
  description = "Launch Template ID"
  value       = aws_launch_template.main.id
}

output "launch_template_arn" {
  description = "Launch Template ARN"
  value       = aws_launch_template.main.arn
}

output "launch_template_name" {
  description = "Launch Template Name"
  value       = aws_launch_template.main.name
}

output "launch_template_latest_version" {
  description = "Latest Launch Template Version"
  value       = aws_launch_template.main.latest_version
}

#############################################
# IAM Outputs
#############################################

output "iam_role_name" {
  description = "EC2 IAM Role Name"
  value       = aws_iam_role.ec2.name
}

output "iam_instance_profile_name" {
  description = "EC2 IAM Instance Profile Name"
  value       = aws_iam_instance_profile.ec2.name
}
