# =============================================================================
# modules/networking/outputs.tf
# Exposes networking resource IDs to the root module and other modules.
# =============================================================================

output "vpc_id" {
  description = "ID of the VPC."
  value       = aws_vpc.main.id
}

output "vpc_cidr_block" {
  description = "CIDR block of the VPC."
  value       = aws_vpc.main.cidr_block
}

output "public_subnet_ids" {
  description = "List of IDs for the public subnets."
  value       = aws_subnet.public[*].id
}

output "private_app_subnet_ids" {
  description = "List of IDs for the private application-tier subnets."
  value       = aws_subnet.private_app[*].id
}

output "private_db_subnet_ids" {
  description = "List of IDs for the private database-tier subnets."
  value       = aws_subnet.private_db[*].id
}

output "internet_gateway_id" {
  description = "ID of the Internet Gateway."
  value       = aws_internet_gateway.main.id
}

output "nat_gateway_ids" {
  description = "List of NAT Gateway IDs (one per AZ)."
  value       = aws_nat_gateway.main[*].id
}

output "nat_gateway_public_ips" {
  description = "List of public Elastic IP addresses assigned to the NAT Gateways."
  value       = aws_eip.nat[*].public_ip
}
