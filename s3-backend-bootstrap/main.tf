
#############################################
# Local Values
#############################################

locals {

  backend_bucket_name = "${var.project_name}-s3-terraform-state"

}

#############################################
# S3 Bucket
#############################################

resource "aws_s3_bucket" "terraform_state" {

  bucket = local.backend_bucket_name
  force_destroy = true

  tags = {

    Name      = local.backend_bucket_name
    Project   = var.project_name
    Purpose   = "Terraform Remote State"
    ManagedBy = "Terraform"

  }

}

#############################################
# Enable Versioning
#############################################

resource "aws_s3_bucket_versioning" "terraform_state" {

  bucket = aws_s3_bucket.terraform_state.id

  versioning_configuration {

    status = "Enabled"

  }

}

#############################################
# Server Side Encryption
#############################################

resource "aws_s3_bucket_server_side_encryption_configuration" "terraform_state" {

  bucket = aws_s3_bucket.terraform_state.id

  rule {

    apply_server_side_encryption_by_default {

      sse_algorithm = "AES256"

    }

  }

}

#############################################
# Block Public Access
#############################################

resource "aws_s3_bucket_public_access_block" "terraform_state" {

  bucket = aws_s3_bucket.terraform_state.id

  block_public_acls       = true
  ignore_public_acls      = true
  block_public_policy     = true
  restrict_public_buckets = true

}

#############################################
# Bucket Ownership Controls
#############################################

resource "aws_s3_bucket_ownership_controls" "terraform_state" {

  bucket = aws_s3_bucket.terraform_state.id

  rule {

    object_ownership = "BucketOwnerEnforced"

  }

}