# =============================================================================
# outputs.tf
# Exposes key resource attributes after a successful apply.
# These values are printed to the terminal and can be consumed by other
# Terraform configurations via `terraform_remote_state`.
# =============================================================================

# -----------------------------------------------------------------------------
# Networking outputs
# -----------------------------------------------------------------------------

output "vpc_id" {
  description = "ID of the VPC."
  value       = module.networking.vpc_id
}

output "public_subnet_ids" {
  description = "IDs of the public subnets."
  value       = module.networking.public_subnet_ids
}

output "private_app_subnet_ids" {
  description = "IDs of the private application-tier subnets."
  value       = module.networking.private_app_subnet_ids
}

output "private_db_subnet_ids" {
  description = "IDs of the private database-tier subnets."
  value       = module.networking.private_db_subnet_ids
}

# -----------------------------------------------------------------------------
# Compute outputs
# -----------------------------------------------------------------------------

output "alb_dns_name" {
  description = "Public DNS name of the Application Load Balancer. Use this URL to reach the application."
  value       = module.compute.alb_dns_name
}

output "alb_zone_id" {
  description = "Hosted zone ID of the ALB (useful for Route 53 alias records)."
  value       = module.compute.alb_zone_id
}

output "asg_name" {
  description = "Name of the Auto Scaling Group."
  value       = module.compute.asg_name
}

output "alb_security_group_id" {
  description = "Security group ID attached to the Application Load Balancer."
  value       = module.compute.alb_security_group_id
}

output "app_security_group_id" {
  description = "Security group ID attached to the application EC2 instances."
  value       = module.compute.app_security_group_id
}

# -----------------------------------------------------------------------------
# Database outputs
# -----------------------------------------------------------------------------

output "db_endpoint" {
  description = "Connection endpoint for the RDS MySQL instance (host:port)."
  value       = module.database.db_endpoint
}

output "db_port" {
  description = "Port the RDS instance is listening on."
  value       = module.database.db_port
}

output "db_name" {
  description = "Name of the initial database created in RDS."
  value       = module.database.db_name
}

output "db_security_group_id" {
  description = "Security group ID attached to the RDS instance."
  value       = module.database.db_security_group_id
}

# -----------------------------------------------------------------------------
# Storage outputs
# -----------------------------------------------------------------------------

output "s3_bucket_name" {
  description = "Name of the S3 bucket used for static assets."
  value       = aws_s3_bucket.static_assets.bucket
}

output "s3_bucket_arn" {
  description = "ARN of the S3 static-assets bucket."
  value       = aws_s3_bucket.static_assets.arn
}
