# =============================================================================
# terraform.tfvars
# Default variable values for the dev environment.
#
# WARNING: This file is committed to version control.
# Do NOT put secrets (passwords, access keys) here.
# Use a separate, git-ignored file (e.g., secrets.auto.tfvars) or
# environment variables (TF_VAR_db_password=...) for sensitive values.
# =============================================================================

# -----------------------------------------------------------------------------
# General
# -----------------------------------------------------------------------------
aws_region   = "us-east-1"
project_name = "three-tier-app"
environment  = "dev"
owner        = "platform-team"

# -----------------------------------------------------------------------------
# Networking
# -----------------------------------------------------------------------------
vpc_cidr           = "10.0.0.0/16"
availability_zones = ["us-east-1a", "us-east-1b"]

# Public subnets — host the ALB and NAT Gateway
public_subnet_cidrs = ["10.0.1.0/24", "10.0.2.0/24"]

# Private app subnets — host the EC2 instances (no direct internet access)
private_app_subnet_cidrs = ["10.0.11.0/24", "10.0.12.0/24"]

# Private DB subnets — host the RDS instance (no internet access at all)
private_db_subnet_cidrs = ["10.0.21.0/24", "10.0.22.0/24"]

# -----------------------------------------------------------------------------
# Compute
# -----------------------------------------------------------------------------
instance_type        = "t3.micro"
ami_id               = "ami-0c02fb55956c7d316" # Amazon Linux 2023 (us-east-1)
asg_min_size         = 2
asg_max_size         = 4
asg_desired_capacity = 2

# Set to the name of an existing EC2 Key Pair to enable SSH access.
# Leave as empty string to launch instances without a key pair.
key_name = ""

# -----------------------------------------------------------------------------
# Database
# -----------------------------------------------------------------------------
db_name              = "appdb"
db_username          = "admin"
# db_password is intentionally omitted here — supply it via:
#   export TF_VAR_db_password="YourSecurePassword123!"
# or create a git-ignored secrets.auto.tfvars file.
db_instance_class          = "db.t3.micro"
db_allocated_storage       = 20
db_engine_version          = "8.0"
db_multi_az                = false
db_backup_retention_period = 7

# -----------------------------------------------------------------------------
# Storage
# -----------------------------------------------------------------------------
# Leave empty to auto-generate a unique bucket name, or set a specific name:
# s3_bucket_name = "my-unique-bucket-name-12345"
s3_bucket_name = ""
