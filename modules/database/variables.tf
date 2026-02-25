# =============================================================================
# modules/database/variables.tf
# Input variables for the database module.
# =============================================================================

variable "name_prefix" {
  description = "Prefix applied to every resource name (e.g. 'three-tier-app-dev')."
  type        = string
}

variable "vpc_id" {
  description = "ID of the VPC where the RDS instance will be deployed."
  type        = string
}

variable "private_db_subnet_ids" {
  description = "List of private DB subnet IDs for the DB subnet group."
  type        = list(string)
}

variable "app_security_group_id" {
  description = "Security group ID of the application tier — allowed to connect to MySQL."
  type        = string
}

variable "db_name" {
  description = "Name of the initial database to create."
  type        = string
  default     = "appdb"
}

variable "db_username" {
  description = "Master username for the RDS instance."
  type        = string
  sensitive   = true
}

variable "db_password" {
  description = "Master password for the RDS instance."
  type        = string
  sensitive   = true
}

variable "db_instance_class" {
  description = "RDS instance class (e.g. db.t3.micro)."
  type        = string
  default     = "db.t3.micro"
}

variable "db_allocated_storage" {
  description = "Initial allocated storage for the RDS instance in GB."
  type        = number
  default     = 20
}

variable "db_engine_version" {
  description = "MySQL engine version."
  type        = string
  default     = "8.0"
}

variable "db_multi_az" {
  description = "Enable Multi-AZ deployment for high availability."
  type        = bool
  default     = false
}

variable "db_backup_retention_period" {
  description = "Number of days to retain automated backups (0 disables backups)."
  type        = number
  default     = 7
}
