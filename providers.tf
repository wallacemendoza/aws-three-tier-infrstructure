# =============================================================================
# providers.tf
# Configures the required Terraform providers and backend settings.
# =============================================================================

terraform {
  required_version = ">= 1.3.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  # Optional: Uncomment and configure to store state remotely in S3
  # backend "s3" {
  #   bucket         = "your-terraform-state-bucket"
  #   key            = "aws-three-tier-infrastructure/terraform.tfstate"
  #   region         = "us-east-1"
  #   dynamodb_table = "terraform-state-lock"
  #   encrypt        = true
  # }
}

# Configure the AWS provider with the region and default tags
provider "aws" {
  region = var.aws_region

  # Default tags applied to every resource created by this provider
  default_tags {
    tags = {
      Project     = var.project_name
      Environment = var.environment
      Owner       = var.owner
      ManagedBy   = "Terraform"
    }
  }
}
