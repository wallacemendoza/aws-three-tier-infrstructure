# =============================================================================
# modules/networking/main.tf
# Provisions all network-layer resources:
#   - VPC
#   - Public subnets (ALB + NAT Gateway)
#   - Private app subnets (EC2 instances)
#   - Private DB subnets (RDS)
#   - Internet Gateway
#   - NAT Gateway (one per AZ for high availability)
#   - Route tables and associations
# =============================================================================

# -----------------------------------------------------------------------------
# VPC
# The top-level network boundary for all resources.
# DNS hostnames are enabled so EC2 instances receive public DNS names.
# -----------------------------------------------------------------------------
resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "${var.name_prefix}-vpc"
  }
}

# -----------------------------------------------------------------------------
# Public Subnets
# One per availability zone. Resources here receive public IP addresses and
# can communicate directly with the Internet via the Internet Gateway.
# Hosts: Application Load Balancer, NAT Gateways.
# -----------------------------------------------------------------------------
resource "aws_subnet" "public" {
  count = length(var.availability_zones)

  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnet_cidrs[count.index]
  availability_zone       = var.availability_zones[count.index]
  # Instances launched here automatically receive a public IP
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.name_prefix}-public-subnet-${count.index + 1}"
    Tier = "public"
  }
}

# -----------------------------------------------------------------------------
# Private App Subnets
# One per availability zone. No public IP assignment.
# Outbound internet access is provided via the NAT Gateway.
# Hosts: EC2 application instances (Auto Scaling Group).
# -----------------------------------------------------------------------------
resource "aws_subnet" "private_app" {
  count = length(var.availability_zones)

  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_app_subnet_cidrs[count.index]
  availability_zone = var.availability_zones[count.index]

  tags = {
    Name = "${var.name_prefix}-private-app-subnet-${count.index + 1}"
    Tier = "private-app"
  }
}

# -----------------------------------------------------------------------------
# Private DB Subnets
# One per availability zone. Completely isolated — no route to the internet.
# Hosts: RDS MySQL instance.
# -----------------------------------------------------------------------------
resource "aws_subnet" "private_db" {
  count = length(var.availability_zones)

  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_db_subnet_cidrs[count.index]
  availability_zone = var.availability_zones[count.index]

  tags = {
    Name = "${var.name_prefix}-private-db-subnet-${count.index + 1}"
    Tier = "private-db"
  }
}

# -----------------------------------------------------------------------------
# Internet Gateway
# Allows resources in public subnets to send/receive traffic to/from the
# public internet.
# -----------------------------------------------------------------------------
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.name_prefix}-igw"
  }
}

# -----------------------------------------------------------------------------
# Elastic IPs for NAT Gateways
# Each NAT Gateway requires a static public IP address.
# -----------------------------------------------------------------------------
resource "aws_eip" "nat" {
  count  = length(var.availability_zones)
  domain = "vpc"

  # Ensure the Internet Gateway exists before allocating the EIP
  depends_on = [aws_internet_gateway.main]

  tags = {
    Name = "${var.name_prefix}-nat-eip-${count.index + 1}"
  }
}

# -----------------------------------------------------------------------------
# NAT Gateways
# One per AZ for high availability. Placed in public subnets.
# Allows private-subnet instances to initiate outbound internet connections
# (e.g., to download packages) without being directly reachable from the internet.
# -----------------------------------------------------------------------------
resource "aws_nat_gateway" "main" {
  count = length(var.availability_zones)

  allocation_id = aws_eip.nat[count.index].id
  subnet_id     = aws_subnet.public[count.index].id

  # NAT Gateway must be created after the Internet Gateway is attached
  depends_on = [aws_internet_gateway.main]

  tags = {
    Name = "${var.name_prefix}-nat-gw-${count.index + 1}"
  }
}

# -----------------------------------------------------------------------------
# Route Table — Public
# A single route table shared by all public subnets.
# Default route sends all non-local traffic to the Internet Gateway.
# -----------------------------------------------------------------------------
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  # Default route: send all internet-bound traffic to the IGW
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = {
    Name = "${var.name_prefix}-public-rt"
  }
}

# Associate each public subnet with the public route table
resource "aws_route_table_association" "public" {
  count = length(var.availability_zones)

  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

# -----------------------------------------------------------------------------
# Route Tables — Private App (one per AZ)
# Each private app subnet gets its own route table pointing to the NAT Gateway
# in the same AZ. This ensures traffic stays within the same AZ for resilience.
# -----------------------------------------------------------------------------
resource "aws_route_table" "private_app" {
  count  = length(var.availability_zones)
  vpc_id = aws_vpc.main.id

  # Default route: send internet-bound traffic through the NAT Gateway in this AZ
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.main[count.index].id
  }

  tags = {
    Name = "${var.name_prefix}-private-app-rt-${count.index + 1}"
  }
}

# Associate each private app subnet with its corresponding route table
resource "aws_route_table_association" "private_app" {
  count = length(var.availability_zones)

  subnet_id      = aws_subnet.private_app[count.index].id
  route_table_id = aws_route_table.private_app[count.index].id
}

# -----------------------------------------------------------------------------
# Route Table — Private DB
# A single route table for all DB subnets with NO default internet route.
# Database instances should never initiate or receive internet connections.
# -----------------------------------------------------------------------------
resource "aws_route_table" "private_db" {
  vpc_id = aws_vpc.main.id

  # No internet route — DB tier is fully isolated

  tags = {
    Name = "${var.name_prefix}-private-db-rt"
  }
}

# Associate each private DB subnet with the DB route table
resource "aws_route_table_association" "private_db" {
  count = length(var.availability_zones)

  subnet_id      = aws_subnet.private_db[count.index].id
  route_table_id = aws_route_table.private_db.id
}
