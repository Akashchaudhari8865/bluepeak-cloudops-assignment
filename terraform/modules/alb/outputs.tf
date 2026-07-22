#############################################
# Application Load Balancer
#############################################

output "alb_id" {
  description = "Application Load Balancer ID"
  value       = aws_lb.main.id
}

output "alb_arn" {
  description = "Application Load Balancer ARN"
  value       = aws_lb.main.arn
}

output "alb_dns_name" {
  description = "Application Load Balancer DNS Name"
  value       = aws_lb.main.dns_name
}

output "alb_zone_id" {
  description = "Application Load Balancer Hosted Zone ID"
  value       = aws_lb.main.zone_id
}

#############################################
# Target Group
#############################################

output "target_group_id" {
  description = "Target Group ID"
  value       = aws_lb_target_group.main.id
}

output "target_group_arn" {
  description = "Target Group ARN"
  value       = aws_lb_target_group.main.arn
}

#############################################
# HTTP Listener
#############################################

output "http_listener_arn" {
  description = "HTTP Listener ARN"
  value       = aws_lb_listener.http.arn
}