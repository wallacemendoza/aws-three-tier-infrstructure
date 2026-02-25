# =============================================================================
# modules/compute/outputs.tf
# Exposes compute resource attributes to the root module.
# =============================================================================

output "alb_dns_name" {
  description = "Public DNS name of the Application Load Balancer."
  value       = aws_lb.main.dns_name
}

output "alb_zone_id" {
  description = "Canonical hosted zone ID of the ALB (for Route 53 alias records)."
  value       = aws_lb.main.zone_id
}

output "alb_arn" {
  description = "ARN of the Application Load Balancer."
  value       = aws_lb.main.arn
}

output "alb_security_group_id" {
  description = "ID of the security group attached to the ALB."
  value       = aws_security_group.alb.id
}

output "app_security_group_id" {
  description = "ID of the security group attached to the application EC2 instances."
  value       = aws_security_group.app.id
}

output "asg_name" {
  description = "Name of the Auto Scaling Group."
  value       = aws_autoscaling_group.app.name
}

output "launch_template_id" {
  description = "ID of the EC2 Launch Template."
  value       = aws_launch_template.app.id
}

output "target_group_arn" {
  description = "ARN of the ALB Target Group."
  value       = aws_lb_target_group.app.arn
}
