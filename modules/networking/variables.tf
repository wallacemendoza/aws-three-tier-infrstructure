# =============================================================================
# modules/networking/variables.tf
# Input variables for the networking module.
# =============================================================================

variable "name_prefix" {
  description = "Prefix applied to every resource name (e.g. 'three-tier-app-dev')."
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC."
  type        = string
}

variable "availability_zones" {
  description = "List of availability zones to deploy subnets into."
  type        = list(string)
}

variable "public_subnet_cidrs" {
  description = "CIDR blocks for the public subnets (one per AZ)."
  type        = list(string)
}

variable "private_app_subnet_cidrs" {
  description = "CIDR blocks for the private application-tier subnets (one per AZ)."
  type        = list(string)
}

variable "private_db_subnet_cidrs" {
  description = "CIDR blocks for the private database-tier subnets (one per AZ)."
  type        = list(string)
}
