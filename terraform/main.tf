#############################################
# Networking Module
#############################################

module "networking" {
  source = "./modules/networking"

  project_name = var.project_name
  environment  = var.environment

  vpc_cidr                 = var.vpc_cidr
  availability_zones       = var.availability_zones
  public_subnet_cidrs      = var.public_subnet_cidrs
  private_app_subnet_cidrs = var.private_app_subnet_cidrs
  private_db_subnet_cidrs  = var.private_db_subnet_cidrs
}

#############################################
# Security Module
#############################################

module "security" {
  source = "./modules/security"

  project_name = var.project_name
  environment  = var.environment

  vpc_id = module.networking.vpc_id
}

#############################################
# ALB Module
#############################################

module "alb" {
  source = "./modules/alb"

  project_name = var.project_name
  environment  = var.environment

  vpc_id            = module.networking.vpc_id
  public_subnet_ids = module.networking.public_subnet_ids

  alb_security_group_id = module.security.alb_security_group_id
}

#############################################
# EC2 Module
#############################################

module "ec2" {
  source = "./modules/ec2"

  project_name = var.project_name
  environment  = var.environment

  app_version = data.archive_file.application.output_md5

  artifact_bucket_name = aws_s3_bucket.artifacts.bucket
  artifact_object_key  = aws_s3_object.application.key

  instance_type = var.instance_type
  key_name      = var.key_name

  private_app_subnet_ids = module.networking.private_app_subnet_ids

  ec2_security_group_id = module.security.ec2_security_group_id
}

#############################################
# Auto Scaling Module
#############################################

module "autoscaling" {
  source = "./modules/autoscaling"

  project_name = var.project_name
  environment  = var.environment

  desired_capacity = var.desired_capacity
  min_size         = var.min_size
  max_size         = var.max_size

  private_subnet_ids = module.networking.private_app_subnet_ids

  launch_template_id = module.ec2.launch_template_id
  launch_template_version = module.ec2.launch_template_latest_version

  target_group_arn = module.alb.target_group_arn
}

#############################################
# RDS Module
#############################################

module "rds" {
  source = "./modules/rds"

  project_name = var.project_name
  environment  = var.environment

  db_name     = var.db_name
  db_username = var.db_username

  private_db_subnet_ids = module.networking.private_db_subnet_ids
  db_security_group_id  = module.security.rds_security_group_id

  multi_az = var.multi_az
}



#############################################
# Package Application
#############################################

data "archive_file" "application" {

  type = "zip"

  source_dir = "${path.root}/../app"

  output_path = "${path.root}/application.zip"

}


resource "aws_s3_bucket" "artifacts" {

  bucket = "${var.project_name}-${var.environment}-artifacts"

  tags = {
    Name = "${var.project_name}-${var.environment}-artifacts"
  }
}

resource "aws_s3_bucket_versioning" "artifacts" {

  bucket = aws_s3_bucket.artifacts.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_public_access_block" "artifacts" {

  bucket = aws_s3_bucket.artifacts.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

#############################################
# Upload Application
#############################################

resource "aws_s3_object" "application" {

  bucket = aws_s3_bucket.artifacts.id

  key = "application.zip"

  source = data.archive_file.application.output_path

  etag = data.archive_file.application.output_md5

  depends_on = [
    aws_s3_bucket_versioning.artifacts,
    aws_s3_bucket_public_access_block.artifacts
  ]
}