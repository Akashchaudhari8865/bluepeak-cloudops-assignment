#############################################
# Auto Scaling Group
#############################################

resource "aws_autoscaling_group" "main" {
  name_prefix               = "${var.project_name}-${var.environment}-asg-"
  min_size                  = var.min_size
  max_size                  = var.max_size
  desired_capacity          = var.desired_capacity
  vpc_zone_identifier       = var.private_subnet_ids
  health_check_type         = "ELB"
  health_check_grace_period = var.health_check_grace_period
  target_group_arns = [
    var.target_group_arn
  ]
  launch_template {
  id      = var.launch_template_id
  version = var.launch_template_version
  }
  instance_refresh {
  strategy = "Rolling"

  triggers = [
    "launch_template"
  ]

  preferences {
    min_healthy_percentage = 50
    instance_warmup        = var.instance_warmup
  }
  }
  tag {
    key                 = "Name"
    value               = "${var.project_name}-${var.environment}-asg-instance"
    propagate_at_launch = true
  }
  tag {
    key                 = "Environment"
    value               = var.environment
    propagate_at_launch = true
  }
  tag {
    key                 = "Project"
    value               = var.project_name
    propagate_at_launch = true
  }
  lifecycle {
    create_before_destroy = true
  }
}


#############################################
# Target Tracking Scaling Policy
# Keeps the ASG within min_size/max_size while
# actually reacting to demand, instead of
# holding a fixed instance count.
#############################################

resource "aws_autoscaling_policy" "cpu_target_tracking" {
  name                   = "${var.project_name}-${var.environment}-cpu-target-tracking"
  autoscaling_group_name = aws_autoscaling_group.main.name
  policy_type            = "TargetTrackingScaling"

  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }
    target_value = var.cpu_target_value
  }
}