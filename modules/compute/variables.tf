# =============================================================================
# modules/compute/variables.tf
# Input variables for the compute module.
# =============================================================================

variable "name_prefix" {
  description = "Prefix applied to every resource name (e.g. 'three-tier-app-dev')."
  type        = string
}

variable "vpc_id" {
  description = "ID of the VPC where compute resources will be deployed."
  type        = string
}

variable "public_subnet_ids" {
  description = "List of public subnet IDs for the Application Load Balancer."
  type        = list(string)
}

variable "private_app_subnet_ids" {
  description = "List of private app subnet IDs for the Auto Scaling Group."
  type        = list(string)
}

variable "instance_type" {
  description = "EC2 instance type for the application servers."
  type        = string
  default     = "t3.micro"
}

variable "ami_id" {
  description = "AMI ID for the EC2 instances."
  type        = string
}

variable "key_name" {
  description = "Name of an existing EC2 Key Pair for SSH access. Empty string disables SSH key."
  type        = string
  default     = ""
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
