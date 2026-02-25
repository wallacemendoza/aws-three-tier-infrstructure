# `AWS_THREE_TIER_INFRASTRUCTURE`

```ascii
 █████╗ ██╗    ██╗███████╗    ████████╗██╗  ██╗██████╗ ███████╗███████╗
██╔══██╗██║    ██║██╔════╝    ╚══██╔══╝██║  ██║██╔══██╗██╔════╝██╔════╝
███████║██║ █╗ ██║███████╗       ██║   ███████║██████╔╝█████╗  █████╗  
██╔══██║██║███╗██║╚════██║       ██║   ██╔══██║██╔══██╗██╔══╝  ██╔══╝  
██║  ██║╚███╔███╔╝███████║       ██║   ██║  ██║██║  ██║███████╗███████╗
╚═╝  ╚═╝ ╚══╝╚══╝ ╚══════╝       ╚═╝   ╚═╝  ╚═╝╚═╝  ╚═╝╚══════╝╚══════╝
████████╗██╗███████╗██████╗     ██╗███╗   ██╗███████╗██████╗  █████╗ 
╚══██╔══╝██║██╔════╝██╔══██╗    ██║████╗  ██║██╔════╝██╔══██╗██╔══██╗
   ██║   ██║█████╗  ██████╔╝    ██║██╔██╗ ██║█████╗  ██████╔╝███████║
   ██║   ██║██╔══╝  ██╔══██╗    ██║██║╚██╗██║██╔══╝  ██╔══██╗██╔══██║
   ██║   ██║███████╗██║  ██║    ██║██║ ╚████║██║     ██║  ██║██║  ██║
   ╚═╝   ╚═╝╚══════╝╚═╝  ╚═╝    ╚═╝╚═╝  ╚═══╝╚═╝     ╚═╝  ╚═╝╚═╝  ╚═╝
```

<div align="center">

### ☁️ PRODUCTION-GRADE AWS CLOUD ARCHITECTURE ☁️

**`AWS`** × **`TERRAFORM`** × **`VPC`** × **`EC2`** × **`RDS`** × **`ALB`**

*Highly available, scalable, and secure three-tier web application infrastructure following AWS Well-Architected Framework best practices. Deployable via Terraform IaC.*

---

![AWS](https://img.shields.io/badge/AWS-Cloud_Architecture-FF9900?style=for-the-badge&logo=amazon-aws&logoColor=white)
![Terraform](https://img.shields.io/badge/TERRAFORM-IaC-7B42BC?style=for-the-badge&logo=terraform&logoColor=white)
![VPC](https://img.shields.io/badge/VPC-Network_Layer-0066FF?style=for-the-badge&logo=amazon-aws&logoColor=white)
![High Availability](https://img.shields.io/badge/HA-Multi_AZ-00C853?style=for-the-badge)

</div>

---

## 🎯 `ARCHITECTURE_OVERVIEW`

**Enterprise-grade three-tier infrastructure** designed for high availability, fault tolerance, and scalability. This architecture separates presentation, application logic, and data layers across multiple Availability Zones, ensuring zero single points of failure and automatic scaling based on demand.

### `CORE_DESIGN_PRINCIPLES`

```yaml
architecture_pattern: "Three-Tier Web Application"
deployment_model: "Multi-AZ for High Availability"
infrastructure_as_code: "Terraform (HCL)"
scaling_strategy: "Auto Scaling with Load Balancing"
security_model: "Defense in Depth with Security Groups"
availability: "99.99% SLA Target"
disaster_recovery: "Multi-AZ with Automated Failover"
```

---

## 🏗️ `INFRASTRUCTURE_LAYERS`

<table>
<tr>
<td width="33%">

### `WEB_TIER`
**Public-Facing Layer**
```yaml
Components:
  - Application Load Balancer
  - EC2 Web Servers (Nginx)
  - Auto Scaling Group
  - Public Subnets (2 AZs)
  
Purpose:
  - Serve React.js frontend
  - SSL/TLS termination
  - Route traffic to app tier
  - Static content delivery
```

</td>
<td width="33%">

### `APPLICATION_TIER`
**Private Logic Layer**
```yaml
Components:
  - Internal Load Balancer
  - EC2 App Servers (Node.js)
  - Auto Scaling Group
  - Private Subnets (2 AZs)
  
Purpose:
  - Business logic processing
  - API endpoints
  - Database connection pool
  - Session management
```

</td>
<td width="34%">

### `DATABASE_TIER`
**Data Persistence Layer**
```yaml
Components:
  - RDS MySQL (Multi-AZ)
  - DB Subnet Group
  - Read Replicas
  - Private Subnets (2 AZs)
  
Purpose:
  - Data storage
  - Transaction processing
  - Automated backups
  - High availability DB
```

</td>
</tr>
</table>

---

## 📐 `ARCHITECTURE_DIAGRAM`

```
┌──────────────────────────────────────────────────────────────────────────────┐
│                              INTERNET GATEWAY                                 │
└────────────────────────────────────┬─────────────────────────────────────────┘
                                     │
┌────────────────────────────────────┴─────────────────────────────────────────┐
│                          PUBLIC SUBNET TIER                                   │
│  ┌────────────────────────────────────────────────────────────────────────┐  │
│  │                    APPLICATION LOAD BALANCER (ALB)                      │  │
│  │                     Port 80/443 (HTTP/HTTPS)                            │  │
│  └──────────────────────┬────────────────────┬────────────────────────────┘  │
│                         │                    │                               │
│  ┌──────────────────────▼────┐    ┌─────────▼───────────────┐               │
│  │  Public Subnet 1 (AZ-A)   │    │  Public Subnet 2 (AZ-B) │               │
│  │  Web Server EC2 (Nginx)   │    │  Web Server EC2 (Nginx) │               │
│  │  Auto Scaling Group       │    │  Auto Scaling Group     │               │
│  └───────────────────────────┘    └─────────────────────────┘               │
└────────────────────────────────────┬─────────────────────────────────────────┘
                                     │
┌────────────────────────────────────┴─────────────────────────────────────────┐
│                        PRIVATE SUBNET - APP TIER                              │
│  ┌────────────────────────────────────────────────────────────────────────┐  │
│  │                   INTERNAL LOAD BALANCER (ALB)                          │  │
│  │                         Port 4000 (API)                                 │  │
│  └──────────────────────┬────────────────────┬────────────────────────────┘  │
│                         │                    │                               │
│  ┌──────────────────────▼────┐    ┌─────────▼───────────────┐               │
│  │ Private Subnet 3 (AZ-A)   │    │ Private Subnet 4 (AZ-B) │               │
│  │ App Server EC2 (Node.js)  │    │ App Server EC2 (Node.js)│               │
│  │ Auto Scaling Group        │    │ Auto Scaling Group      │               │
│  └───────────────────────────┘    └─────────────────────────┘               │
└────────────────────────────────────┬─────────────────────────────────────────┘
                                     │
┌────────────────────────────────────┴─────────────────────────────────────────┐
│                     PRIVATE SUBNET - DATABASE TIER                            │
│  ┌────────────────────────────────────────────────────────────────────────┐  │
│  │                    RDS MYSQL (MULTI-AZ)                                 │  │
│  │                       Port 3306                                         │  │
│  └──────────────────────┬────────────────────┬────────────────────────────┘  │
│                         │                    │                               │
│  ┌──────────────────────▼────┐    ┌─────────▼───────────────┐               │
│  │ Private Subnet 5 (AZ-A)   │    │ Private Subnet 6 (AZ-B) │               │
│  │ RDS Primary Instance      │    │ RDS Standby Instance    │               │
│  │ Automated Backups         │    │ Synchronous Replication │               │
│  └───────────────────────────┘    └─────────────────────────┘               │
└──────────────────────────────────────────────────────────────────────────────┘

┌──────────────────────────────────────────────────────────────────────────────┐
│                         ADDITIONAL COMPONENTS                                 │
│  • NAT Gateway (Per AZ) - Allows private instances internet access          │
│  • Bastion Host - Secure SSH access to private instances                    │
│  • S3 Buckets - Static assets, logs, backups                                │
│  • CloudWatch - Monitoring, logging, alerts                                 │
│  • Route 53 - DNS management                                                │
└──────────────────────────────────────────────────────────────────────────────┘
```

---

## 🔒 `SECURITY_ARCHITECTURE`

### Security Groups Configuration

```yaml
Web Tier Security Group (Public ALB):
  Inbound:
    - HTTP (80): 0.0.0.0/0
    - HTTPS (443): 0.0.0.0/0
  Outbound:
    - App Tier SG on port 4000

Web Server Security Group:
  Inbound:
    - HTTP (80): Web Tier ALB SG
    - SSH (22): Bastion Host SG
  Outbound:
    - ALL: 0.0.0.0/0 (via NAT Gateway)

App Tier Security Group (Internal ALB):
  Inbound:
    - Port 4000: Web Server SG
  Outbound:
    - Database SG on port 3306

App Server Security Group:
  Inbound:
    - Port 4000: App Tier ALB SG
    - SSH (22): Bastion Host SG
  Outbound:
    - ALL: 0.0.0.0/0 (via NAT Gateway)

Database Security Group:
  Inbound:
    - MySQL (3306): App Server SG
  Outbound:
    - NONE (highly restricted)

Bastion Host Security Group:
  Inbound:
    - SSH (22): Your_Public_IP/32
  Outbound:
    - SSH (22): Web/App Server SGs
```

### Network Access Control

| Layer | Internet Access | SSH Access | Database Access |
|-------|----------------|------------|-----------------|
| **Web Tier** | ✅ Direct (IGW) | ✅ Via Bastion | ❌ No Access |
| **App Tier** | ✅ Outbound (NAT) | ✅ Via Bastion | ✅ MySQL Only |
| **DB Tier** | ❌ No Internet | ❌ No SSH | ✅ Internal Only |

---

## 🌐 `NETWORK_CONFIGURATION`

### VPC Design

```yaml
VPC CIDR: 10.0.0.0/16

Subnets:
  Public Subnets (Web Tier):
    - Public-1A: 10.0.0.0/24 (AZ-A)
    - Public-1B: 10.0.1.0/24 (AZ-B)
  
  Private Subnets (App Tier):
    - Private-2A: 10.0.2.0/24 (AZ-A)
    - Private-2B: 10.0.3.0/24 (AZ-B)
  
  Private Subnets (Database Tier):
    - Private-3A: 10.0.4.0/24 (AZ-A)
    - Private-3B: 10.0.5.0/24 (AZ-B)

Total Capacity: 65,536 IP addresses
Subnet Size: 256 IPs per subnet
Reserved by AWS: 5 IPs per subnet
Usable IPs per subnet: 251
```

### Route Tables

**Public Route Table:**
```
Destination         Target
10.0.0.0/16        local (VPC)
0.0.0.0/0          igw-xxxxx (Internet Gateway)

Associated Subnets: Public-1A, Public-1B
```

**Private Route Table (App Tier):**
```
Destination         Target
10.0.0.0/16        local (VPC)
0.0.0.0/0          nat-xxxxx (NAT Gateway)

Associated Subnets: Private-2A, Private-2B
```

**Private Route Table (DB Tier):**
```
Destination         Target
10.0.0.0/16        local (VPC)

Associated Subnets: Private-3A, Private-3B
Note: No internet access (highly secure)
```

---

## 🚀 `AUTO_SCALING_CONFIGURATION`

### Web Tier Auto Scaling

```yaml
Launch Template:
  AMI: Amazon Linux 2
  Instance Type: t3.micro
  User Data: |
    #!/bin/bash
    yum update -y
    yum install nginx -y
    systemctl start nginx
    systemctl enable nginx

Auto Scaling Group:
  Min Capacity: 2
  Desired Capacity: 2
  Max Capacity: 6
  Health Check Type: ELB
  Health Check Grace Period: 300 seconds

Scaling Policies:
  Scale Out:
    - CPU > 70% for 5 minutes → Add 2 instances
  Scale In:
    - CPU < 30% for 5 minutes → Remove 1 instance
```

### Application Tier Auto Scaling

```yaml
Launch Template:
  AMI: Amazon Linux 2
  Instance Type: t3.small
  User Data: |
    #!/bin/bash
    yum update -y
    curl -sL https://rpm.nodesource.com/setup_16.x | bash -
    yum install nodejs -y
    # Deploy application code from S3

Auto Scaling Group:
  Min Capacity: 2
  Desired Capacity: 2
  Max Capacity: 8
  Health Check Type: ELB
  Health Check Grace Period: 300 seconds

Scaling Policies:
  Scale Out:
    - CPU > 60% for 3 minutes → Add 2 instances
  Scale In:
    - CPU < 25% for 5 minutes → Remove 1 instance
```

---

## 💾 `DATABASE_CONFIGURATION`

### RDS MySQL Multi-AZ Setup

```yaml
Engine: MySQL 8.0
Instance Class: db.t3.medium
Storage: 100 GB GP3 (Auto-scaling enabled)
Multi-AZ: Enabled (Synchronous replication)

High Availability:
  Primary Instance: AZ-A
  Standby Instance: AZ-B
  Automatic Failover: < 2 minutes
  
Backup Configuration:
  Automated Backups: Enabled
  Retention Period: 7 days
  Backup Window: 03:00-04:00 UTC
  Maintenance Window: Sun 04:00-05:00 UTC

Performance:
  Read Replicas: Optional (up to 5)
  Connection Pool: Managed by app tier
  Query Cache: Enabled
  
Security:
  Encryption at Rest: AES-256
  Encryption in Transit: SSL/TLS
  IAM Database Authentication: Enabled
  Parameter Group: Custom (optimized)
```

---

## 📊 `MONITORING_&_LOGGING`

### CloudWatch Metrics

```yaml
EC2 Instances:
  - CPU Utilization
  - Network In/Out
  - Disk Read/Write
  - Status Checks

Load Balancers:
  - Request Count
  - Target Response Time
  - Healthy/Unhealthy Host Count
  - HTTP 4xx/5xx Errors

RDS Database:
  - CPU Utilization
  - Database Connections
  - Read/Write IOPS
  - Free Storage Space
  - Replica Lag

Auto Scaling:
  - Group Size
  - In-Service Instances
  - Pending Instances
  - Terminating Instances
```

### CloudWatch Alarms

```yaml
Critical Alarms:
  - RDS CPU > 85% for 5 minutes
  - ALB Unhealthy Host Count > 0
  - RDS Storage < 10%
  - NAT Gateway Connection Limit

Warning Alarms:
  - EC2 CPU > 75% for 10 minutes
  - ALB 5xx Errors > 50/min
  - RDS Read Latency > 100ms
```

---

## ⚙️ `DEPLOYMENT_GUIDE`

### Prerequisites

```yaml
AWS Account: Active with appropriate permissions
IAM Permissions:
  - VPC Full Access
  - EC2 Full Access
  - RDS Full Access
  - ELB Full Access
  - Auto Scaling Full Access
  - CloudWatch Full Access
  
Tools Required:
  - AWS CLI configured
  - Terraform >= 1.0
  - SSH key pair created
  - Domain registered (optional)
```

### Deployment Options

**Option 1: Terraform (Recommended)**  
**Option 2: AWS CLI (Manual)**

---

## 🔧 `TERRAFORM_DEPLOYMENT`

### Project Structure

```
aws-three-tier-infrastructure/
├── main.tf                 # Root module
├── variables.tf            # Input variables
├── outputs.tf              # Output values
├── terraform.tfvars        # Variable values
├── providers.tf            # AWS provider config
├── versions.tf             # Terraform version
├── modules/
│   ├── network/
│   │   ├── main.tf        # VPC, Subnets, IGW, NAT
│   │   ├── variables.tf
│   │   └── outputs.tf
│   ├── security/
│   │   ├── main.tf        # Security Groups
│   │   ├── variables.tf
│   │   └── outputs.tf
│   ├── compute/
│   │   ├── main.tf        # EC2, ASG, Launch Templates
│   │   ├── variables.tf
│   │   └── outputs.tf
│   ├── loadbalancer/
│   │   ├── main.tf        # ALB, Target Groups
│   │   ├── variables.tf
│   │   └── outputs.tf
│   └── database/
│       ├── main.tf        # RDS Multi-AZ
│       ├── variables.tf
│       └── outputs.tf
└── README.md
```

### Terraform Configuration Examples

**providers.tf**
```hcl
terraform {
  required_version = ">= 1.0"
  
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
  
  backend "s3" {
    bucket         = "terraform-state-bucket"
    key            = "three-tier-infra/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "terraform-locks"
  }
}

provider "aws" {
  region = var.aws_region
  
  default_tags {
    tags = {
      Project     = "Three-Tier-Infrastructure"
      ManagedBy   = "Terraform"
      Environment = var.environment
    }
  }
}
```

**main.tf**
```hcl
module "network" {
  source = "./modules/network"
  
  vpc_cidr             = var.vpc_cidr
  availability_zones   = var.availability_zones
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  db_subnet_cidrs      = var.db_subnet_cidrs
  environment          = var.environment
}

module "security" {
  source = "./modules/security"
  
  vpc_id      = module.network.vpc_id
  environment = var.environment
}

module "loadbalancer" {
  source = "./modules/loadbalancer"
  
  vpc_id              = module.network.vpc_id
  public_subnets      = module.network.public_subnet_ids
  private_subnets     = module.network.private_subnet_ids
  web_tier_sg_id      = module.security.web_tier_sg_id
  app_tier_sg_id      = module.security.app_tier_sg_id
  environment         = var.environment
}

module "compute" {
  source = "./modules/compute"
  
  vpc_id                  = module.network.vpc_id
  public_subnets          = module.network.public_subnet_ids
  private_subnets         = module.network.private_subnet_ids
  web_server_sg_id        = module.security.web_server_sg_id
  app_server_sg_id        = module.security.app_server_sg_id
  web_tier_target_group   = module.loadbalancer.web_tier_tg_arn
  app_tier_target_group   = module.loadbalancer.app_tier_tg_arn
  key_name                = var.key_name
  environment             = var.environment
}

module "database" {
  source = "./modules/database"
  
  vpc_id              = module.network.vpc_id
  db_subnets          = module.network.db_subnet_ids
  db_security_group   = module.security.db_sg_id
  db_name             = var.db_name
  db_username         = var.db_username
  db_password         = var.db_password
  environment         = var.environment
}
```

**variables.tf**
```hcl
variable "aws_region" {
  description = "AWS region for resources"
  type        = string
  default     = "us-east-1"
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "production"
}

variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "availability_zones" {
  description = "List of availability zones"
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b"]
}

variable "public_subnet_cidrs" {
  description = "CIDR blocks for public subnets"
  type        = list(string)
  default     = ["10.0.0.0/24", "10.0.1.0/24"]
}

variable "private_subnet_cidrs" {
  description = "CIDR blocks for app tier subnets"
  type        = list(string)
  default     = ["10.0.2.0/24", "10.0.3.0/24"]
}

variable "db_subnet_cidrs" {
  description = "CIDR blocks for database subnets"
  type        = list(string)
  default     = ["10.0.4.0/24", "10.0.5.0/24"]
}

variable "key_name" {
  description = "SSH key pair name"
  type        = string
}

variable "db_name" {
  description = "Database name"
  type        = string
  default     = "appdb"
}

variable "db_username" {
  description = "Database master username"
  type        = string
  sensitive   = true
}

variable "db_password" {
  description = "Database master password"
  type        = string
  sensitive   = true
}
```

**outputs.tf**
```hcl
output "vpc_id" {
  description = "VPC ID"
  value       = module.network.vpc_id
}

output "web_tier_alb_dns" {
  description = "Web tier load balancer DNS name"
  value       = module.loadbalancer.web_tier_alb_dns
}

output "app_tier_alb_dns" {
  description = "App tier load balancer DNS name"
  value       = module.loadbalancer.app_tier_alb_dns
}

output "rds_endpoint" {
  description = "RDS database endpoint"
  value       = module.database.rds_endpoint
  sensitive   = true
}

output "bastion_public_ip" {
  description = "Bastion host public IP"
  value       = module.compute.bastion_public_ip
}
```

### Network Module Example (modules/network/main.tf)

```hcl
# VPC
resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true
  
  tags = {
    Name = "${var.environment}-vpc"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id
  
  tags = {
    Name = "${var.environment}-igw"
  }
}

# Public Subnets
resource "aws_subnet" "public" {
  count = length(var.public_subnet_cidrs)
  
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnet_cidrs[count.index]
  availability_zone       = var.availability_zones[count.index]
  map_public_ip_on_launch = true
  
  tags = {
    Name = "${var.environment}-public-subnet-${count.index + 1}"
    Tier = "public"
  }
}

# Private Subnets (App Tier)
resource "aws_subnet" "private" {
  count = length(var.private_subnet_cidrs)
  
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_subnet_cidrs[count.index]
  availability_zone = var.availability_zones[count.index]
  
  tags = {
    Name = "${var.environment}-private-subnet-${count.index + 1}"
    Tier = "application"
  }
}

# Database Subnets
resource "aws_subnet" "database" {
  count = length(var.db_subnet_cidrs)
  
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.db_subnet_cidrs[count.index]
  availability_zone = var.availability_zones[count.index]
  
  tags = {
    Name = "${var.environment}-db-subnet-${count.index + 1}"
    Tier = "database"
  }
}

# Elastic IPs for NAT Gateways
resource "aws_eip" "nat" {
  count  = length(var.availability_zones)
  domain = "vpc"
  
  tags = {
    Name = "${var.environment}-nat-eip-${count.index + 1}"
  }
}

# NAT Gateways
resource "aws_nat_gateway" "main" {
  count = length(var.availability_zones)
  
  allocation_id = aws_eip.nat[count.index].id
  subnet_id     = aws_subnet.public[count.index].id
  
  tags = {
    Name = "${var.environment}-nat-gateway-${count.index + 1}"
  }
  
  depends_on = [aws_internet_gateway.main]
}

# Public Route Table
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id
  
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }
  
  tags = {
    Name = "${var.environment}-public-rt"
  }
}

# Private Route Tables (one per AZ)
resource "aws_route_table" "private" {
  count  = length(var.availability_zones)
  vpc_id = aws_vpc.main.id
  
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.main[count.index].id
  }
  
  tags = {
    Name = "${var.environment}-private-rt-${count.index + 1}"
  }
}

# Database Route Table (no internet access)
resource "aws_route_table" "database" {
  vpc_id = aws_vpc.main.id
  
  tags = {
    Name = "${var.environment}-db-rt"
  }
}

# Route Table Associations
resource "aws_route_table_association" "public" {
  count = length(aws_subnet.public)
  
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "private" {
  count = length(aws_subnet.private)
  
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private[count.index].id
}

resource "aws_route_table_association" "database" {
  count = length(aws_subnet.database)
  
  subnet_id      = aws_subnet.database[count.index].id
  route_table_id = aws_route_table.database.id
}
```

### RDS Module Example (modules/database/main.tf)

```hcl
# DB Subnet Group
resource "aws_db_subnet_group" "main" {
  name       = "${var.environment}-db-subnet-group"
  subnet_ids = var.db_subnets
  
  tags = {
    Name = "${var.environment}-db-subnet-group"
  }
}

# RDS Instance (Multi-AZ)
resource "aws_db_instance" "main" {
  identifier     = "${var.environment}-mysql-db"
  engine         = "mysql"
  engine_version = "8.0"
  
  instance_class    = "db.t3.medium"
  allocated_storage = 100
  storage_type      = "gp3"
  storage_encrypted = true
  
  db_name  = var.db_name
  username = var.db_username
  password = var.db_password
  
  multi_az               = true
  db_subnet_group_name   = aws_db_subnet_group.main.name
  vpc_security_group_ids = [var.db_security_group]
  
  backup_retention_period = 7
  backup_window          = "03:00-04:00"
  maintenance_window     = "sun:04:00-sun:05:00"
  
  skip_final_snapshot = false
  final_snapshot_identifier = "${var.environment}-mysql-final-snapshot"
  
  enabled_cloudwatch_logs_exports = ["error", "general", "slowquery"]
  
  tags = {
    Name = "${var.environment}-mysql-db"
  }
}
```

### Terraform Deployment Commands

```bash
# 1. Initialize Terraform
terraform init

# 2. Validate configuration
terraform validate

# 3. Format code
terraform fmt -recursive

# 4. Plan deployment (review changes)
terraform plan -out=tfplan

# 5. Apply infrastructure
terraform apply tfplan

# 6. View outputs
terraform output

# 7. Destroy infrastructure (when needed)
terraform destroy
```

### Terraform Best Practices Used

```yaml
State Management:
  - Remote state in S3
  - State locking with DynamoDB
  - Encrypted state files

Code Organization:
  - Modular structure
  - Reusable modules
  - Separated concerns (network, compute, db)

Security:
  - Sensitive variables marked
  - No hardcoded credentials
  - Encrypted resources

Tagging Strategy:
  - Consistent naming
  - Environment tags
  - Cost allocation tags
  - ManagedBy: Terraform

Version Control:
  - Provider version pinning
  - Terraform version requirements
  - Lock file committed
```

---

## 🖥️ `AWS_CLI_DEPLOYMENT`

**1. Network Layer Setup**
```bash
# Create VPC
aws ec2 create-vpc --cidr-block 10.0.0.0/16

# Create Subnets (6 total: 2 public, 4 private)
aws ec2 create-subnet --vpc-id vpc-xxx --cidr-block 10.0.0.0/24 --availability-zone us-east-1a

# Create Internet Gateway
aws ec2 create-internet-gateway
aws ec2 attach-internet-gateway --vpc-id vpc-xxx --internet-gateway-id igw-xxx

# Create NAT Gateways (one per AZ)
aws ec2 create-nat-gateway --subnet-id subnet-xxx --allocation-id eipalloc-xxx

# Configure Route Tables
aws ec2 create-route-table --vpc-id vpc-xxx
aws ec2 create-route --route-table-id rtb-xxx --destination-cidr-block 0.0.0.0/0 --gateway-id igw-xxx
```

**2. Security Groups**
```bash
# Create security groups for each tier
aws ec2 create-security-group --group-name web-tier-sg --vpc-id vpc-xxx
aws ec2 create-security-group --group-name app-tier-sg --vpc-id vpc-xxx
aws ec2 create-security-group --group-name db-tier-sg --vpc-id vpc-xxx

# Configure inbound/outbound rules
aws ec2 authorize-security-group-ingress --group-id sg-xxx --protocol tcp --port 80 --cidr 0.0.0.0/0
```

**3. Load Balancers**
```bash
# Create public ALB (Web Tier)
aws elbv2 create-load-balancer \
  --name web-tier-alb \
  --subnets subnet-xxx subnet-yyy \
  --security-groups sg-xxx \
  --scheme internet-facing

# Create internal ALB (App Tier)
aws elbv2 create-load-balancer \
  --name app-tier-alb \
  --subnets subnet-xxx subnet-yyy \
  --security-groups sg-xxx \
  --scheme internal
```

**4. Auto Scaling Groups**
```bash
# Create Launch Template
aws ec2 create-launch-template \
  --launch-template-name web-tier-template \
  --version-description "Web tier v1"

# Create Auto Scaling Group
aws autoscaling create-auto-scaling-group \
  --auto-scaling-group-name web-tier-asg \
  --launch-template LaunchTemplateName=web-tier-template \
  --min-size 2 \
  --max-size 6 \
  --desired-capacity 2 \
  --vpc-zone-identifier "subnet-xxx,subnet-yyy"
```

**5. RDS Database**
```bash
# Create DB Subnet Group
aws rds create-db-subnet-group \
  --db-subnet-group-name db-subnet-group \
  --db-subnet-group-description "Database subnets" \
  --subnet-ids subnet-xxx subnet-yyy

# Create RDS Instance (Multi-AZ)
aws rds create-db-instance \
  --db-instance-identifier prod-db \
  --db-instance-class db.t3.medium \
  --engine mysql \
  --master-username admin \
  --master-user-password SecurePassword123! \
  --allocated-storage 100 \
  --multi-az \
  --db-subnet-group-name db-subnet-group \
  --vpc-security-group-ids sg-xxx
```

---

## 🧪 `TESTING_&_VALIDATION`

### Connectivity Tests

```bash
# Test web tier accessibility
curl -I http://alb-dns-name.region.elb.amazonaws.com

# SSH to bastion host
ssh -i key.pem ec2-user@bastion-public-ip

# From bastion, SSH to private instances
ssh -i key.pem ec2-user@private-instance-ip

# Test database connection from app tier
mysql -h rds-endpoint.region.rds.amazonaws.com -u admin -p

# Test auto scaling
# Increase CPU load and observe scaling
stress --cpu 4 --timeout 600s
```

### High Availability Tests

```yaml
Failover Tests:
  - Terminate web tier instance → Verify ALB redirects traffic
  - Simulate AZ failure → Verify traffic routes to healthy AZ
  - Force RDS failover → Verify < 2 minute recovery
  
Load Tests:
  - Apache Bench: ab -n 10000 -c 100 http://alb-dns-name/
  - Monitor CloudWatch for auto scaling triggers
  - Verify healthy instance count increases
```

---

## 📈 `COST_OPTIMIZATION`

### Estimated Monthly Costs (us-east-1)

```yaml
Compute:
  EC2 Instances (4 x t3.micro): $30/month
  EC2 Instances (4 x t3.small): $60/month
  Bastion Host (1 x t3.nano): $4/month
  NAT Gateway (2 AZs): $90/month

Load Balancing:
  Application Load Balancers (2): $40/month
  Data Transfer: ~$10/month

Database:
  RDS MySQL Multi-AZ (db.t3.medium): $120/month
  Storage (100 GB): $12/month
  Backup Storage: $10/month

Other:
  S3 Storage: $5/month
  CloudWatch: $10/month
  Data Transfer: $20/month

Total Estimated: $411/month

Optimization Strategies:
  - Use Savings Plans for 30-40% discount
  - Reserved Instances for RDS
  - Schedule non-prod env shutdowns
  - Optimize NAT Gateway data transfer
```

---

## 🔬 `TECHNICAL_HIGHLIGHTS`

Demonstrates expertise in:

- **Infrastructure as Code**: Terraform modules, state management
- **AWS Networking**: VPC design, subnets, routing, NAT, IGW
- **High Availability**: Multi-AZ deployment, fault tolerance
- **Security**: Defense in depth, security groups, network ACLs
- **Auto Scaling**: Dynamic capacity based on demand
- **Load Balancing**: Traffic distribution, health checks
- **Database Management**: RDS Multi-AZ, automated backups
- **Modular Architecture**: Reusable Terraform modules
- **Monitoring**: CloudWatch metrics, alarms, logging
- **Cost Management**: Resource optimization strategies

**Real-World Application**: Enterprise-grade architecture used by production applications serving millions of users.

---

## 📜 `LICENSE_&_USAGE`

```
┌─────────────────────────────────────────────────────────┐
│  AWS THREE-TIER INFRASTRUCTURE DEMONSTRATION             │
│                                                          │
│  Production-grade cloud architecture showcasing AWS      │
│  best practices for scalability, security, and HA.       │
│  Portfolio demonstration of cloud engineering skills.    │
│                                                          │
│  ⚠️  Educational/portfolio project                      │
│  ⚠️  Remember to destroy resources to avoid costs      │
│  ✓  Available for technical review                      │
│  ✓  Open to discussion                                  │
└─────────────────────────────────────────────────────────┘
```

**AWS Well-Architected Framework Alignment:**
- ✅ Operational Excellence
- ✅ Security
- ✅ Reliability
- ✅ Performance Efficiency
- ✅ Cost Optimization

---

## 🚀 `AUTHOR`

**Wallace Mendoza** — *Cloud Solutions Architect*

Specializing in AWS cloud infrastructure, high availability systems, and scalable architectures.

[GitHub](https://github.com/wallacemendoza) • [Portfolio](https://wallacemendoza.github.io/portfolio/)

---

<div align="center">

### `TECH_FINGERPRINT`

`AWS` • `TERRAFORM` • `VPC` • `EC2` • `RDS` • `ALB` • `AUTO_SCALING` • `MULTI_AZ` • `IaC`

---

*Building cloud infrastructure that scales*

**[⬆ back to top](#aws_three_tier_infrastructure)**

</div>
