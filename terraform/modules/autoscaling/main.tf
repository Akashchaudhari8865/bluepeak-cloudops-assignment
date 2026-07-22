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
    version = "$Latest"
  }
  instance_refresh {
    strategy = "Rolling"
    preferences {
      min_healthy_percentage = 50
      instance_warmup        = var.instance_warmup
      skip_matching          = true
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
