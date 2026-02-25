# =============================================================================
# main.tf
# Root module — wires together the networking, compute, and database modules,
# and provisions the S3 static-assets bucket directly.
# =============================================================================

# -----------------------------------------------------------------------------
# Local values — derive commonly-used computed values once
# -----------------------------------------------------------------------------
locals {
  # Prefix used in every resource name for easy identification
  name_prefix = "${var.project_name}-${var.environment}"

  # Auto-generate an S3 bucket name if the user did not supply one
  s3_bucket_name = var.s3_bucket_name != "" ? var.s3_bucket_name : "${local.name_prefix}-static-assets-${random_id.bucket_suffix.hex}"
}

# Random suffix to guarantee a globally-unique S3 bucket name
resource "random_id" "bucket_suffix" {
  byte_length = 4
}

# =============================================================================
# MODULE: Networking
# Creates the VPC, subnets, Internet Gateway, NAT Gateway, and route tables.
# =============================================================================
module "networking" {
  source = "./modules/networking"

  name_prefix              = local.name_prefix
  vpc_cidr                 = var.vpc_cidr
  availability_zones       = var.availability_zones
  public_subnet_cidrs      = var.public_subnet_cidrs
  private_app_subnet_cidrs = var.private_app_subnet_cidrs
  private_db_subnet_cidrs  = var.private_db_subnet_cidrs
}

# =============================================================================
# MODULE: Compute
# Creates security groups, the Application Load Balancer, launch template,
# and Auto Scaling Group running nginx.
# =============================================================================
module "compute" {
  source = "./modules/compute"

  name_prefix          = local.name_prefix
  vpc_id               = module.networking.vpc_id
  public_subnet_ids    = module.networking.public_subnet_ids
  private_app_subnet_ids = module.networking.private_app_subnet_ids
  instance_type        = var.instance_type
  ami_id               = var.ami_id
  key_name             = var.key_name
  asg_min_size         = var.asg_min_size
  asg_max_size         = var.asg_max_size
  asg_desired_capacity = var.asg_desired_capacity
}

# =============================================================================
# MODULE: Database
# Creates the DB subnet group, security group, and RDS MySQL instance.
# =============================================================================
module "database" {
  source = "./modules/database"

  name_prefix                = local.name_prefix
  vpc_id                     = module.networking.vpc_id
  private_db_subnet_ids      = module.networking.private_db_subnet_ids
  app_security_group_id      = module.compute.app_security_group_id
  db_name                    = var.db_name
  db_username                = var.db_username
  db_password                = var.db_password
  db_instance_class          = var.db_instance_class
  db_allocated_storage       = var.db_allocated_storage
  db_engine_version          = var.db_engine_version
  db_multi_az                = var.db_multi_az
  db_backup_retention_period = var.db_backup_retention_period
}

# =============================================================================
# S3 Bucket — Static Assets
# Stores static files (images, CSS, JS) served by the application.
# =============================================================================

# The bucket itself
resource "aws_s3_bucket" "static_assets" {
  bucket = local.s3_bucket_name

  # Prevent accidental deletion of the bucket when it contains objects
  # Set to true in production; false here for easier teardown in dev
  force_destroy = true

  tags = {
    Name = "${local.name_prefix}-static-assets"
  }
}

# Enable versioning so previous object versions can be recovered
resource "aws_s3_bucket_versioning" "static_assets" {
  bucket = aws_s3_bucket.static_assets.id

  versioning_configuration {
    status = "Enabled"
  }
}

# Enable server-side encryption using AES-256 (SSE-S3)
resource "aws_s3_bucket_server_side_encryption_configuration" "static_assets" {
  bucket = aws_s3_bucket.static_assets.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
    # Enforce encryption even if the uploader does not specify it
    bucket_key_enabled = true
  }
}

# Block all public access — objects are served via the application, not directly
resource "aws_s3_bucket_public_access_block" "static_assets" {
  bucket = aws_s3_bucket.static_assets.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Lifecycle rule: move objects to cheaper storage after 90 days,
# and expire non-current versions after 30 days to control costs
resource "aws_s3_bucket_lifecycle_configuration" "static_assets" {
  bucket = aws_s3_bucket.static_assets.id

  rule {
    id     = "transition-and-expire"
    status = "Enabled"

    # Required filter block — empty filter applies the rule to all objects
    filter {}

    # Transition current objects to Standard-IA after 90 days
    transition {
      days          = 90
      storage_class = "STANDARD_IA"
    }

    # Permanently delete non-current (old) versions after 30 days
    noncurrent_version_expiration {
      noncurrent_days = 30
    }
  }
}
