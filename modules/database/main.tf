# =============================================================================
# modules/database/main.tf
# Provisions all database-layer resources:
#   - Security Group for the RDS instance
#   - DB Subnet Group (spans private DB subnets)
#   - RDS MySQL instance
# =============================================================================

# -----------------------------------------------------------------------------
# Security Group — RDS Database
# Allows inbound MySQL traffic (port 3306) only from the application
# EC2 instances (via the app security group). No internet access.
# -----------------------------------------------------------------------------
resource "aws_security_group" "db" {
  name        = "${var.name_prefix}-db-sg"
  description = "Allow MySQL inbound traffic from the application tier only"
  vpc_id      = var.vpc_id

  # Accept MySQL connections only from the application security group
  ingress {
    description     = "MySQL from app tier"
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [var.app_security_group_id]
  }

  # Allow all outbound traffic (needed for RDS to reach AWS services)
  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.name_prefix}-db-sg"
  }
}

# -----------------------------------------------------------------------------
# DB Subnet Group
# Tells RDS which subnets it may place the primary and standby instances in.
# Must span at least two AZs to support Multi-AZ deployments.
# -----------------------------------------------------------------------------
resource "aws_db_subnet_group" "main" {
  name        = "${var.name_prefix}-db-subnet-group"
  description = "Subnet group for the ${var.name_prefix} RDS instance"
  subnet_ids  = var.private_db_subnet_ids

  tags = {
    Name = "${var.name_prefix}-db-subnet-group"
  }
}

# -----------------------------------------------------------------------------
# RDS MySQL Instance
# Single-AZ by default (set db_multi_az = true for production).
# Automated backups are retained for db_backup_retention_period days.
# Storage is encrypted at rest using the default AWS-managed KMS key.
# -----------------------------------------------------------------------------
resource "aws_db_instance" "main" {
  identifier = "${var.name_prefix}-mysql"

  # Engine configuration
  engine         = "mysql"
  engine_version = var.db_engine_version

  # Instance sizing
  instance_class        = var.db_instance_class
  allocated_storage     = var.db_allocated_storage
  max_allocated_storage = var.db_allocated_storage * 2 # Allow autoscaling up to 2x initial size
  storage_type          = "gp3"

  # Encrypt the database storage at rest using the default RDS KMS key
  storage_encrypted = true

  # Database credentials
  db_name  = var.db_name
  username = var.db_username
  password = var.db_password

  # Network configuration
  db_subnet_group_name   = aws_db_subnet_group.main.name
  vpc_security_group_ids = [aws_security_group.db.id]
  publicly_accessible    = false # Never expose the DB to the internet

  # High availability — set to true in production
  multi_az = var.db_multi_az

  # Backup configuration
  backup_retention_period = var.db_backup_retention_period
  backup_window           = "03:00-04:00" # UTC — low-traffic window
  maintenance_window      = "Mon:04:00-Mon:05:00" # UTC — after backup window

  # Prevent accidental deletion of the database
  # Set to true in production; false here for easier teardown in dev
  deletion_protection = false

  # Skip final snapshot when destroying (set to false in production)
  skip_final_snapshot       = true
  final_snapshot_identifier = "${var.name_prefix}-mysql-final-snapshot"

  # Enable enhanced monitoring (requires an IAM role in production)
  # monitoring_interval = 60
  # monitoring_role_arn = aws_iam_role.rds_monitoring.arn

  # Enable Performance Insights for query-level monitoring
  # Note: Not supported on db.t3.micro — disable for free-tier/dev instances
  performance_insights_enabled = false

  # Automatically apply minor version upgrades during the maintenance window
  auto_minor_version_upgrade = true

  tags = {
    Name = "${var.name_prefix}-mysql"
  }
}
