#############################################
# Auto Scaling Group
#############################################

output "autoscaling_group_id" {
  description = "Auto Scaling group ID"
  value       = aws_autoscaling_group.main.id
}

output "autoscaling_group_name" {
  description = "Auto Scaling group name"
  value       = aws_autoscaling_group.main.name
}

output "autoscaling_group_arn" {
  description = "Auto Scaling group ARN"
  value       = aws_autoscaling_group.main.arn
}
