# AWS Three-Tier Infrastructure

A production-ready Terraform project that provisions a **three-tier web application architecture** on AWS. The infrastructure is modular, fully tagged, and follows AWS and Terraform best practices.

---

## Architecture Overview

```
                          ┌─────────────────────────────────────────────────────────┐
                          │                        AWS Cloud                         │
                          │                                                           │
                          │   ┌─────────────────────────────────────────────────┐   │
                          │   │                    VPC (10.0.0.0/16)             │   │
                          │   │                                                   │   │
  Internet ──────────────►│   │  ┌──────────────────────────────────────────┐   │   │
                          │   │  │           PUBLIC TIER (Tier 1)            │   │   │
                          │   │  │                                            │   │   │
                          │   │  │  ┌──────────────┐  ┌──────────────┐      │   │   │
                          │   │  │  │ Public Subnet│  │ Public Subnet│      │   │   │
                          │   │  │  │  us-east-1a  │  │  us-east-1b  │      │   │   │
                          │   │  │  │ 10.0.1.0/24  │  │ 10.0.2.0/24  │      │   │   │
                          │   │  │  │              │  │              │      │   │   │
                          │   │  │  │  [NAT GW 1]  │  │  [NAT GW 2]  │      │   │   │
                          │   │  │  └──────┬───────┘  └──────┬───────┘      │   │   │
                          │   │  │         │                  │              │   │   │
                          │   │  │  ┌──────┴──────────────────┴──────┐      │   │   │
                          │   │  │  │   Application Load Balancer     │      │   │   │
                          │   │  │  │   (Internet-facing, port 80)    │      │   │   │
                          │   │  │  └──────────────────┬─────────────┘      │   │   │
                          │   │  └─────────────────────│────────────────────┘   │   │
                          │   │                         │                         │   │
                          │   │  ┌──────────────────────▼───────────────────┐   │   │
                          │   │  │         PRIVATE APP TIER (Tier 2)         │   │   │
                          │   │  │                                            │   │   │
                          │   │  │  ┌──────────────┐  ┌──────────────┐      │   │   │
                          │   │  │  │Private Subnet│  │Private Subnet│      │   │   │
                          │   │  │  │  us-east-1a  │  │  us-east-1b  │      │   │   │
                          │   │  │  │10.0.11.0/24  │  │10.0.12.0/24  │      │   │   │
                          │   │  │  │              │  │              │      │   │   │
                          │   │  │  │ [EC2 nginx]  │  │ [EC2 nginx]  │      │   │   │
                          │   │  │  │ (ASG min: 2) │  │ (ASG max: 4) │      │   │   │
                          │   │  │  └──────────────┘  └──────────────┘      │   │   │
                          │   │  └──────────────────────┬───────────────────┘   │   │
                          │   │                          │                        │   │
                          │   │  ┌───────────────────────▼──────────────────┐   │   │
                          │   │  │         PRIVATE DB TIER (Tier 3)          │   │   │
                          │   │  │                                            │   │   │
                          │   │  │  ┌──────────────┐  ┌──────────────┐      │   │   │
                          │   │  │  │Private Subnet│  │Private Subnet│      │   │   │
                          │   │  │  │  us-east-1a  │  │  us-east-1b  │      │   │   │
                          │   │  │  │10.0.21.0/24  │  │10.0.22.0/24  │      │   │   │
                          │   │  │  │              │  │              │      │   │   │
                          │   │  │  │  [RDS MySQL] │  │  (standby)   │      │   │   │
                          │   │  │  └──────────────┘  └──────────────┘      │   │   │
                          │   │  └────────────────────────────────────────── ┘   │   │
                          │   │                                                   │   │
                          │   │  ┌─────────────────────────────────────────┐     │   │
                          │   │  │  Internet Gateway  ◄──── Route Table    │     │   │
                          │   │  └─────────────────────────────────────────┘     │   │
                          │   └─────────────────────────────────────────────────┘   │
                          │                                                           │
                          │   ┌─────────────────────────────────────────────────┐   │
                          │   │         S3 Bucket (Static Assets)                │   │
                          │   │   Versioning: ON  |  Encryption: AES-256         │   │
                          │   └─────────────────────────────────────────────────┘   │
                          └─────────────────────────────────────────────────────────┘
```

### Traffic Flow

1. **User → ALB**: HTTP/HTTPS requests arrive at the internet-facing Application Load Balancer in the public subnets.
2. **ALB → EC2**: The ALB forwards requests to healthy nginx instances in the private app subnets via the target group.
3. **EC2 → RDS**: Application instances connect to the MySQL database on port 3306 within the private DB subnets.
4. **EC2 → Internet (outbound)**: Instances in private subnets reach the internet (e.g., for package updates) through the NAT Gateways in the public subnets.
5. **EC2 → S3**: Application instances access static assets stored in the S3 bucket.

---

## Project Structure

```
aws-three-tier-infrastructure/
├── main.tf                    # Root module — wires all modules together + S3 bucket
├── variables.tf               # All input variable declarations
├── outputs.tf                 # Key resource attributes printed after apply
├── providers.tf               # AWS provider + Terraform version constraints
├── terraform.tfvars           # Default variable values (no secrets)
├── .gitignore                 # Excludes state files, .terraform/, secrets
├── README.md                  # This file
└── modules/
    ├── networking/
    │   ├── main.tf            # VPC, subnets, IGW, NAT GW, route tables
    │   ├── variables.tf       # Networking input variables
    │   └── outputs.tf         # VPC ID, subnet IDs, gateway IDs
    ├── compute/
    │   ├── main.tf            # Security groups, ALB, launch template, ASG, scaling policies
    │   ├── variables.tf       # Compute input variables
    │   └── outputs.tf         # ALB DNS, ASG name, security group IDs
    └── database/
        ├── main.tf            # Security group, DB subnet group, RDS MySQL instance
        ├── variables.tf       # Database input variables
        └── outputs.tf         # DB endpoint, port, ARN, security group ID
```

---

## Resources Provisioned

| Resource | Count | Description |
|---|---|---|
| VPC | 1 | 10.0.0.0/16 with DNS support |
| Public Subnets | 2 | One per AZ — hosts ALB and NAT Gateways |
| Private App Subnets | 2 | One per AZ — hosts EC2 instances |
| Private DB Subnets | 2 | One per AZ — hosts RDS |
| Internet Gateway | 1 | Provides internet access to public subnets |
| NAT Gateways | 2 | One per AZ — outbound internet for private subnets |
| Elastic IPs | 2 | Assigned to NAT Gateways |
| Route Tables | 4 | 1 public + 2 private-app + 1 private-db |
| Security Groups | 3 | ALB, App, Database |
| Application Load Balancer | 1 | Internet-facing, HTTP listener on port 80 |
| ALB Target Group | 1 | HTTP health checks on `/` |
| Launch Template | 1 | Amazon Linux 2023 + nginx user-data |
| Auto Scaling Group | 1 | Min 2, Max 4, Desired 2 instances |
| CloudWatch Alarms | 2 | Scale-out (CPU > 70%) and scale-in (CPU < 30%) |
| RDS MySQL Instance | 1 | MySQL 8.0, gp3 storage, encrypted |
| DB Subnet Group | 1 | Spans both private DB subnets |
| S3 Bucket | 1 | Versioning + AES-256 encryption + lifecycle rules |

---

## Prerequisites

Before deploying, ensure you have the following installed and configured:

1. **Terraform** >= 1.3.0
   ```bash
   terraform -version
   ```
   Download: https://developer.hashicorp.com/terraform/downloads

2. **AWS CLI** >= 2.x configured with credentials
   ```bash
   aws configure
   # or use environment variables:
   export AWS_ACCESS_KEY_ID="your-access-key"
   export AWS_SECRET_ACCESS_KEY="your-secret-key"
   export AWS_DEFAULT_REGION="us-east-1"
   ```

3. **AWS IAM permissions** — your IAM user/role needs permissions to create:
   - VPC, Subnets, Internet Gateway, NAT Gateway, Route Tables
   - EC2 (Launch Templates, Auto Scaling Groups, Security Groups)
   - Elastic Load Balancing
   - RDS
   - S3
   - CloudWatch

4. **Git** (to clone and version-control the project)

---

## Configuration

### Required: Set the Database Password

The `db_password` variable has no default and must be provided before running `terraform apply`. **Never commit passwords to version control.**

**Option A — Environment variable (recommended for CI/CD):**
```bash
export TF_VAR_db_password="YourSecurePassword123!"
```

**Option B — Git-ignored secrets file:**
```bash
# Create a file that is excluded by .gitignore
cat > secrets.auto.tfvars <<EOF
db_password = "YourSecurePassword123!"
EOF
```

### Optional: Customize Variables

Edit `terraform.tfvars` to change any default values:

```hcl
# Example: deploy to us-west-2 with a larger instance
aws_region    = "us-west-2"
instance_type = "t3.small"
db_multi_az   = true   # Enable for production
```

> **Note:** If you change `aws_region` or `availability_zones`, also update `ami_id` to a valid AMI for that region. Find the latest Amazon Linux 2023 AMI with:
> ```bash
> aws ec2 describe-images \
>   --owners amazon \
>   --filters "Name=name,Values=al2023-ami-*-x86_64" \
>   --query "sort_by(Images, &CreationDate)[-1].ImageId" \
>   --output text \
>   --region us-east-1
> ```

---

## Deployment

### 1. Clone the repository

```bash
git clone https://github.com/your-username/aws-three-tier-infrastructure.git
cd aws-three-tier-infrastructure
```

### 2. Set the database password

```bash
export TF_VAR_db_password="YourSecurePassword123!"
```

### 3. Initialize Terraform

Downloads the AWS provider plugin and prepares the working directory.

```bash
terraform init
```

### 4. Review the execution plan

Previews all resources that will be created without making any changes.

```bash
terraform plan
```

### 5. Apply the configuration

Creates all AWS resources. Type `yes` when prompted to confirm.

```bash
terraform apply
```

> **Note:** The full deployment takes approximately **10–15 minutes**, primarily due to the NAT Gateways (~2 min each) and the RDS instance (~5–10 min).

### 6. Access the application

After a successful apply, Terraform prints the ALB DNS name:

```
Outputs:

alb_dns_name = "three-tier-app-dev-alb-1234567890.us-east-1.elb.amazonaws.com"
```

Open that URL in your browser to see the nginx welcome page.

---

## Outputs Reference

| Output | Description |
|---|---|
| `vpc_id` | ID of the VPC |
| `public_subnet_ids` | IDs of the public subnets |
| `private_app_subnet_ids` | IDs of the private app subnets |
| `private_db_subnet_ids` | IDs of the private DB subnets |
| `alb_dns_name` | **Public URL** of the Application Load Balancer |
| `alb_zone_id` | Hosted zone ID (for Route 53 alias records) |
| `asg_name` | Name of the Auto Scaling Group |
| `alb_security_group_id` | Security group ID of the ALB |
| `app_security_group_id` | Security group ID of the EC2 instances |
| `db_endpoint` | RDS connection endpoint (host:port) |
| `db_port` | RDS port (3306) |
| `db_name` | Name of the initial database |
| `db_security_group_id` | Security group ID of the RDS instance |
| `s3_bucket_name` | Name of the static-assets S3 bucket |
| `s3_bucket_arn` | ARN of the S3 bucket |

---

## Destroying Resources

To tear down **all** resources created by this project:

```bash
terraform destroy
```

Type `yes` when prompted. This will permanently delete all AWS resources including the RDS database and S3 bucket.

> ⚠️ **Warning:** In production, set `deletion_protection = true` on the RDS instance and `force_destroy = false` on the S3 bucket to prevent accidental data loss.

---

## Security Considerations

| Concern | Implementation |
|---|---|
| EC2 instances not directly internet-accessible | Instances live in private subnets; only the ALB is public |
| Database not internet-accessible | RDS in private subnets with `publicly_accessible = false` |
| DB only reachable from app tier | DB security group allows port 3306 only from the app security group |
| Encrypted storage | RDS storage encrypted; EC2 EBS volumes encrypted; S3 AES-256 |
| No secrets in code | `db_password` has no default; must be supplied via env var or ignored file |
| S3 public access blocked | All four public-access-block settings enabled |

---

## Cost Estimate (us-east-1, dev defaults)

| Resource | Approx. Monthly Cost |
|---|---|
| 2× NAT Gateways | ~$65 |
| 2× t3.micro EC2 (ASG) | ~$15 |
| 1× db.t3.micro RDS | ~$15 |
| 1× Application Load Balancer | ~$16 |
| S3 (minimal usage) | < $1 |
| **Total** | **~$112/month** |

> Costs vary by usage. Use the [AWS Pricing Calculator](https://calculator.aws/) for a precise estimate.
> To minimize costs in dev, you can reduce NAT Gateways to 1 by modifying the networking module.

---

## Extending the Project

Some common next steps:

- **HTTPS**: Add an ACM certificate and an HTTPS listener (port 443) to the ALB, then redirect HTTP → HTTPS.
- **Custom Domain**: Create a Route 53 hosted zone and an alias record pointing to the ALB.
- **Bastion Host**: Add a bastion EC2 instance in a public subnet for SSH access to private instances.
- **Remote State**: Uncomment the `backend "s3"` block in `providers.tf` and create the S3 bucket + DynamoDB table for state locking.
- **Production Hardening**: Set `db_multi_az = true`, `deletion_protection = true`, `skip_final_snapshot = false`.
- **WAF**: Attach an AWS WAF Web ACL to the ALB for additional protection.

---

## License

This project is released under the [MIT License](LICENSE).
