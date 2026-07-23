#############################################
# ALB Security Group
#############################################

resource "aws_security_group" "alb" {
  name        = "${var.project_name}-${var.environment}-alb-sg"
  description = "Security Group for Application Load Balancer"
  vpc_id      = var.vpc_id
  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "${var.project_name}-${var.environment}-alb-sg"
  }
}

#############################################
# EC2 Security Group
#############################################

resource "aws_security_group" "ec2" {

  name        = "${var.project_name}-${var.environment}-ec2-sg"
  description = "Security Group for EC2"
  vpc_id      = var.vpc_id

  ingress {
    description = "HTTP From ALB"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    security_groups = [
      aws_security_group.alb.id
    ]
  }

  # No SSH ingress: the EC2 instance role already grants SSM Session Manager
  # access (see modules/ec2/main.tf, AmazonSSMManagedInstanceCore), so no
  # inbound port needs to be open for shell access, and every session is
  # logged in CloudTrail.

  egress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    cidr_blocks = [
      "0.0.0.0/0"
    ]
  }
  tags = {
    Name = "${var.project_name}-${var.environment}-ec2-sg"
  }
}

#############################################
# RDS Security Group
#############################################

resource "aws_security_group" "rds" {
  name        = "${var.project_name}-${var.environment}-rds-sg"
  description = "Security Group for RDS"
  vpc_id      = var.vpc_id
  ingress {
    description = "MySQL"
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    security_groups = [
      aws_security_group.ec2.id
    ]
  }

  egress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    cidr_blocks = [
      "0.0.0.0/0"
    ]
  }
  tags = {
    Name = "${var.project_name}-${var.environment}-rds-sg"
  }
}