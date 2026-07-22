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
  password = var.db_password

  engine         = var.engine
  engine_version = var.engine_version

  #############################################
  # Instance Configuration
  #############################################

  instance_class    = var.instance_class
  allocated_storage = var.allocated_storage
  storage_type      = var.storage_type

  storage_encrypted = var.storage_encrypted

  #############################################
  # Networking
  #############################################

  db_subnet_group_name = aws_db_subnet_group.main.name
  vpc_security_group_ids = [
    var.db_security_group_id
  ]
  publicly_accessible = var.publicly_accessible
  #############################################
  # High Availability
  #############################################
  multi_az = var.multi_az
  #############################################
  # Backup Configuration
  #############################################
  backup_retention_period  = var.backup_retention_period
  delete_automated_backups = true
  skip_final_snapshot      = var.skip_final_snapshot
  #############################################
  # Maintenance
  #############################################
  auto_minor_version_upgrade = true
  apply_immediately          = true
  #############################################
  # Protection
  #############################################
  deletion_protection = false
  #############################################
  # Monitoring
  #############################################
  monitoring_interval          = 0
  performance_insights_enabled = false
  #############################################
  # Tags
  #############################################
  tags = {
    Name = "${var.project_name}-${var.environment}-mysql"
  }
}