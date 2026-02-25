# =============================================================================
# variables.tf
# Defines all input variables for the root module.
# Override defaults in terraform.tfvars or via environment variables.
# =============================================================================

# -----------------------------------------------------------------------------
# General / Global
# -----------------------------------------------------------------------------

variable "aws_region" {
  description = "AWS region where all resources will be deployed."
  type        = string
  default     = "us-east-1"
}

variable "project_name" {
  description = "Short name for the project, used in resource names and tags."
  type        = string
  default     = "three-tier-app"
}

variable "environment" {
  description = "Deployment environment (e.g. dev, staging, prod)."
  type        = string
  default     = "dev"
}

variable "owner" {
  description = "Name or team responsible for these resources (used in tags)."
  type        = string
  default     = "platform-team"
}

# -----------------------------------------------------------------------------
# Networking
# -----------------------------------------------------------------------------

variable "vpc_cidr" {
  description = "CIDR block for the VPC."
  type        = string
  default     = "10.0.0.0/16"
}

variable "availability_zones" {
  description = "List of two availability zones to spread resources across."
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b"]
}

variable "public_subnet_cidrs" {
  description = "CIDR blocks for the public subnets (one per AZ)."
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_app_subnet_cidrs" {
  description = "CIDR blocks for the private application-tier subnets (one per AZ)."
  type        = list(string)
  default     = ["10.0.11.0/24", "10.0.12.0/24"]
}

variable "private_db_subnet_cidrs" {
  description = "CIDR blocks for the private database-tier subnets (one per AZ)."
  type        = list(string)
  default     = ["10.0.21.0/24", "10.0.22.0/24"]
}

# -----------------------------------------------------------------------------
# Compute
# -----------------------------------------------------------------------------

variable "instance_type" {
  description = "EC2 instance type for the application servers."
  type        = string
  default     = "t3.micro"
}

variable "ami_id" {
  description = "AMI ID for the EC2 instances (Amazon Linux 2023 in us-east-1 by default)."
  type        = string
  default     = "ami-0c02fb55956c7d316" # Amazon Linux 2023 (us-east-1)
}

variable "asg_min_size" {
  description = "Minimum number of EC2 instances in the Auto Scaling Group."
  type        = number
  default     = 2
}

variable "asg_max_size" {
  description = "Maximum number of EC2 instances in the Auto Scaling Group."
  type        = number
  default     = 4
}

variable "asg_desired_capacity" {
  description = "Desired number of EC2 instances in the Auto Scaling Group."
  type        = number
  default     = 2
}

variable "key_name" {
  description = "Name of an existing EC2 Key Pair for SSH access to app instances. Leave empty to disable SSH."
  type        = string
  default     = ""
}

# -----------------------------------------------------------------------------
# Database
# -----------------------------------------------------------------------------

variable "db_name" {
  description = "Name of the initial database to create in RDS."
  type        = string
  default     = "appdb"
}

variable "db_username" {
  description = "Master username for the RDS instance."
  type        = string
  sensitive   = true
  default     = "admin"
}

variable "db_password" {
  description = "Master password for the RDS instance. Must be at least 8 characters."
  type        = string
  sensitive   = true
  # No default — must be supplied via terraform.tfvars or environment variable
}

variable "db_instance_class" {
  description = "RDS instance class."
  type        = string
  default     = "db.t3.micro"
}

variable "db_allocated_storage" {
  description = "Allocated storage for the RDS instance in gigabytes."
  type        = number
  default     = 20
}

variable "db_engine_version" {
  description = "MySQL engine version for the RDS instance."
  type        = string
  default     = "8.0"
}

variable "db_multi_az" {
  description = "Enable Multi-AZ deployment for the RDS instance (recommended for production)."
  type        = bool
  default     = false
}

variable "db_backup_retention_period" {
  description = "Number of days to retain automated RDS backups (0 disables backups)."
  type        = number
  default     = 7
}

# -----------------------------------------------------------------------------
# Storage
# -----------------------------------------------------------------------------

variable "s3_bucket_name" {
  description = "Globally unique name for the S3 static-assets bucket. Leave empty to auto-generate."
  type        = string
  default     = ""
}
