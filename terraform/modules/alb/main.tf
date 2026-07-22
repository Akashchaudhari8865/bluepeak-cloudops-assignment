#############################################
# Application Load Balancer
#############################################

resource "aws_lb" "main" {
  name               = "${var.project_name}-${var.environment}-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups = [
    var.alb_security_group_id
  ]
  subnets                    = var.public_subnet_ids
  enable_deletion_protection = false
  idle_timeout               = 60
  tags = {
    Name = "${var.project_name}-${var.environment}-alb"
  }
}

#############################################
# Target Group
#############################################

resource "aws_lb_target_group" "main" {

  name        = "${var.project_name}-${var.environment}-tg"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "instance"
  health_check {
    enabled             = true
    path                = var.health_check_path
    protocol            = var.health_check_protocol
    port                = var.health_check_port
    healthy_threshold   = 3
    unhealthy_threshold = 3
    timeout             = 5
    interval            = 30
    matcher             = "200"

  }

  tags = {
    Name = "${var.project_name}-${var.environment}-tg"
  }
}

#############################################
# HTTP Listener
#############################################

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.main.arn
  port              = 80
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.main.arn
  }
  tags = {
    Name = "${var.project_name}-${var.environment}-http-listener"
  }
}