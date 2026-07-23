#############################################
# DB Subnet Group
#############################################

resource "aws_db_subnet_group" "main" {

  name = "${var.project_name}-${var.environment}-db-subnet-group"

  subnet_ids = var.private_db_subnet_ids

  tags = {
    Name = "${var.project_name}-${var.environment}-db-subnet-group"
  }
}

#############################################
# RDS MySQL Instance
#############################################

resource "aws_db_instance" "main" {

  identifier = "${var.project_name}-${var.environment}-mysql"

  #############################################
  # Database Configuration
  #############################################

  db_name  = var.db_name
  username = var.db_username

  manage_master_user_password = true

  engine               = var.engine
  engine_version       = var.engine_version
  instance_class       = var.instance_class
  allocated_storage    = var.allocated_storage
  storage_type         = var.storage_type
  storage_encrypted    = true
  kms_key_id           = aws_kms_key.rds.arn
  db_subnet_group_name = aws_db_subnet_group.main.name
  vpc_security_group_ids = [
    var.db_security_group_id
  ]
  publicly_accessible          = var.publicly_accessible
  multi_az                     = var.multi_az
  backup_retention_period      = var.backup_retention_period
  delete_automated_backups     = true
  skip_final_snapshot          = var.skip_final_snapshot
  auto_minor_version_upgrade   = true
  apply_immediately            = true
  deletion_protection          = false
  monitoring_interval          = 0
  performance_insights_enabled = false
  tags = {
    Name = "${var.project_name}-${var.environment}-mysql"
  }
}

#############################################
# KMS Key for RDS Encryption
#############################################

resource "aws_kms_key" "rds" {
  description             = "KMS key for RDS encryption"
  deletion_window_in_days = 7
  enable_key_rotation     = true

  tags = {
    Name = "${var.project_name}-${var.environment}-rds-kms"
  }
}

resource "aws_kms_alias" "rds" {
  name          = "alias/${var.project_name}-${var.environment}-rds"
  target_key_id = aws_kms_key.rds.key_id
}