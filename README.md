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

**`AWS`** × **`VPC`** × **`EC2`** × **`RDS`** × **`ALB`** × **`AUTOSCALING`**

*Highly available, scalable, and secure three-tier web application infrastructure following AWS Well-Architected Framework best practices*

---

![AWS](https://img.shields.io/badge/AWS-Cloud_Architecture-FF9900?style=for-the-badge&logo=amazon-aws&logoColor=white)
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
  - SSH key pair created
  - Domain registered (optional)
```

### Step-by-Step Deployment

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

- **AWS Networking**: VPC design, subnets, routing, NAT, IGW
- **High Availability**: Multi-AZ deployment, fault tolerance
- **Security**: Defense in depth, security groups, network ACLs
- **Auto Scaling**: Dynamic capacity based on demand
- **Load Balancing**: Traffic distribution, health checks
- **Database Management**: RDS Multi-AZ, automated backups
- **Infrastructure as Code**: Repeatable deployments
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

`AWS` • `VPC` • `EC2` • `RDS` • `ALB` • `AUTO_SCALING` • `MULTI_AZ` • `HIGH_AVAILABILITY`

---

*Building cloud infrastructure that scales*

**[⬆ back to top](#aws_three_tier_infrastructure)**

</div>
