#############################################
# Latest Amazon Linux 2023 AMI
#############################################

data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["al2023-ami-*-x86_64"]
  }
  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

#############################################
# IAM Role
#############################################

resource "aws_iam_role" "ec2" {
  name = "${var.project_name}-${var.environment}-${var.iam_role_name}"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
  tags = {
    Name = "${var.project_name}-${var.environment}-ec2-role"
  }
}

#############################################
# Attach Amazon SSM Managed Policy
#############################################

resource "aws_iam_role_policy_attachment" "ssm" {
  role       = aws_iam_role.ec2.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}


#############################################
# Allow EC2 to Download Application from S3
#############################################

resource "aws_iam_role_policy" "artifact_bucket_access" {
  name = "${var.project_name}-${var.environment}-artifact-access"
  role = aws_iam_role.ec2.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:GetObject"
        ]
        Resource = "arn:aws:s3:::${var.artifact_bucket_name}/${var.artifact_object_key}"
      },
      {
        Effect = "Allow"
        Action = [
          "s3:ListBucket"
        ]
        Resource = "arn:aws:s3:::${var.artifact_bucket_name}"
      }
    ]
  })
}

#############################################
# IAM Instance Profile
#############################################

resource "aws_iam_instance_profile" "ec2" {
  name = "${var.project_name}-${var.environment}-instance-profile"
  role = aws_iam_role.ec2.name
  depends_on = [
    aws_iam_role_policy_attachment.ssm,
    aws_iam_role_policy.artifact_bucket_access
  ]
  tags = {
    Name = "${var.project_name}-${var.environment}-instance-profile"
  }
}

#############################################
# Launch Template
#############################################

resource "aws_launch_template" "main" {
  depends_on = [
  aws_iam_instance_profile.ec2,
  aws_iam_role_policy.artifact_bucket_access
]
  name_prefix   = "${var.project_name}-${var.environment}-lt-"
  image_id      = data.aws_ami.amazon_linux.id
  instance_type = var.instance_type
  key_name      = var.key_name
  #############################################
  # IAM Instance Profile
  #############################################
  iam_instance_profile {
    name = aws_iam_instance_profile.ec2.name
  }

  #############################################
  # Security Group
  #############################################
  vpc_security_group_ids = [
    var.ec2_security_group_id
  ]

  #############################################
  # Root Volume
  #############################################

  block_device_mappings {
    device_name = "/dev/xvda"
    ebs {
      volume_size           = var.root_volume_size
      volume_type           = var.root_volume_type
      encrypted             = true
      delete_on_termination = true
    }

  }

  #############################################
  # User Data
  #############################################

  user_data = base64encode(
    templatefile("${path.module}/userdata.sh.tpl", {
      app_name            = var.app_name
      artifact_bucket     = var.artifact_bucket_name
      artifact_object_key = var.artifact_object_key
      app_version         = var.app_version
    })
  )

  #############################################
  # Monitoring
  #############################################

  monitoring {
    enabled = true
  }

  #############################################
  # Metadata Options
  #############################################

  metadata_options {
    http_endpoint               = "enabled"
    http_tokens                 = "required"
    http_put_response_hop_limit = 2
  }

  #############################################
  # Tag EC2 Instance
  #############################################

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name        = "${var.project_name}-${var.environment}-ec2"
      Environment = var.environment
      Application = var.app_name
    }
  }

  #############################################
  # Tag Root Volume
  #############################################

  tag_specifications {
    resource_type = "volume"
    tags = {
      Name = "${var.project_name}-${var.environment}-ebs"
    }
  }
  tags = {
  Name       = "${var.project_name}-${var.environment}-launch-template"
  AppVersion = var.app_version
  }
}
