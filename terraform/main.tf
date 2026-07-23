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

  db_security_group_id = module.security.rds_security_group_id
}