# =============================================================================
# modules/compute/main.tf
# Provisions all compute-layer resources:
#   - Security Group for the Application Load Balancer (public-facing)
#   - Security Group for the EC2 application instances (private)
#   - Application Load Balancer, Target Group, and Listener
#   - Launch Template with nginx user-data
#   - Auto Scaling Group
# =============================================================================

# -----------------------------------------------------------------------------
# Security Group — Application Load Balancer
# Allows inbound HTTP (80) and HTTPS (443) from the internet.
# All outbound traffic is permitted so the ALB can forward to app instances.
# -----------------------------------------------------------------------------
resource "aws_security_group" "alb" {
  name        = "${var.name_prefix}-alb-sg"
  description = "Allow HTTP and HTTPS inbound traffic to the Application Load Balancer"
  vpc_id      = var.vpc_id

  # Allow HTTP from anywhere
  ingress {
    description = "HTTP from internet"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow HTTPS from anywhere
  ingress {
    description = "HTTPS from internet"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow all outbound traffic (to reach app instances)
  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.name_prefix}-alb-sg"
  }
}

# -----------------------------------------------------------------------------
# Security Group — Application EC2 Instances
# Allows inbound HTTP only from the ALB security group.
# Allows all outbound traffic (needed for package downloads via NAT Gateway).
# Optionally allows SSH from within the VPC if a key pair is provided.
# -----------------------------------------------------------------------------
resource "aws_security_group" "app" {
  name        = "${var.name_prefix}-app-sg"
  description = "Allow HTTP from ALB; allow all outbound traffic"
  vpc_id      = var.vpc_id

  # Accept HTTP traffic only from the ALB (not directly from the internet)
  ingress {
    description     = "HTTP from ALB"
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.alb.id]
  }

  # Allow SSH from within the VPC (useful for bastion-host access)
  ingress {
    description = "SSH from within VPC"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"] # Restrict to VPC CIDR
  }

  # Allow all outbound traffic (e.g., to reach RDS, S3, package repos)
  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.name_prefix}-app-sg"
  }
}

# -----------------------------------------------------------------------------
# Application Load Balancer
# Internet-facing ALB placed in the public subnets.
# Distributes incoming HTTP traffic across healthy EC2 instances.
# -----------------------------------------------------------------------------
resource "aws_lb" "main" {
  name               = "${var.name_prefix}-alb"
  internal           = false          # Internet-facing
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb.id]
  subnets            = var.public_subnet_ids

  # Enable deletion protection in production to prevent accidental removal
  enable_deletion_protection = false

  tags = {
    Name = "${var.name_prefix}-alb"
  }
}

# -----------------------------------------------------------------------------
# ALB Target Group
# Defines how the ALB routes requests to registered EC2 instances.
# Health checks ping the root path every 30 seconds.
# -----------------------------------------------------------------------------
resource "aws_lb_target_group" "app" {
  name     = "${var.name_prefix}-app-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  # Health check configuration
  health_check {
    enabled             = true
    path                = "/"           # nginx default page
    port                = "traffic-port"
    protocol            = "HTTP"
    healthy_threshold   = 2             # Mark healthy after 2 consecutive successes
    unhealthy_threshold = 3             # Mark unhealthy after 3 consecutive failures
    timeout             = 5             # Seconds to wait for a response
    interval            = 30            # Seconds between health checks
    matcher             = "200"         # Expect HTTP 200 OK
  }

  tags = {
    Name = "${var.name_prefix}-app-tg"
  }
}

# -----------------------------------------------------------------------------
# ALB Listener — HTTP on port 80
# Forwards all incoming HTTP requests to the app target group.
# In production, add an HTTPS listener and redirect HTTP → HTTPS.
# -----------------------------------------------------------------------------
resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.main.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app.arn
  }
}

# -----------------------------------------------------------------------------
# Launch Template
# Defines the configuration for EC2 instances launched by the ASG.
# User-data script installs and starts nginx on first boot.
# -----------------------------------------------------------------------------
resource "aws_launch_template" "app" {
  name_prefix   = "${var.name_prefix}-lt-"
  image_id      = var.ami_id
  instance_type = var.instance_type

  # Attach the app security group
  vpc_security_group_ids = [aws_security_group.app.id]

  # Attach a key pair only if one was provided
  key_name = var.key_name != "" ? var.key_name : null

  # User-data: runs on first boot to install and start nginx
  # The script is base64-encoded automatically by Terraform
  user_data = base64encode(<<-EOF
    #!/bin/bash
    # Update all installed packages
    yum update -y

    # Install nginx from the Amazon Linux extras repository
    amazon-linux-extras install nginx1 -y 2>/dev/null || \
      dnf install -y nginx

    # Write a simple HTML page that shows the instance hostname
    cat > /usr/share/nginx/html/index.html <<HTML
    <!DOCTYPE html>
    <html>
      <head><title>Three-Tier App</title></head>
      <body>
        <h1>Hello from $(hostname -f)</h1>
        <p>Environment: ${var.name_prefix}</p>
      </body>
    </html>
    HTML

    # Enable nginx to start on reboot and start it now
    systemctl enable nginx
    systemctl start nginx
  EOF
  )

  # Assign an IAM instance profile if needed (add here)
  # iam_instance_profile { name = aws_iam_instance_profile.app.name }

  # Enable detailed monitoring for better CloudWatch metrics
  monitoring {
    enabled = true
  }

  # Tag the root EBS volume
  block_device_mappings {
    device_name = "/dev/xvda"
    ebs {
      volume_size           = 20    # GB
      volume_type           = "gp3"
      delete_on_termination = true
      encrypted             = true  # Encrypt the root volume at rest
    }
  }

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "${var.name_prefix}-app-instance"
    }
  }

  tag_specifications {
    resource_type = "volume"
    tags = {
      Name = "${var.name_prefix}-app-volume"
    }
  }

  lifecycle {
    # Create a new launch template version before destroying the old one
    create_before_destroy = true
  }
}

# -----------------------------------------------------------------------------
# Auto Scaling Group
# Maintains the desired number of EC2 instances across private app subnets.
# Registers instances with the ALB target group automatically.
# -----------------------------------------------------------------------------
resource "aws_autoscaling_group" "app" {
  name                = "${var.name_prefix}-asg"
  min_size            = var.asg_min_size
  max_size            = var.asg_max_size
  desired_capacity    = var.asg_desired_capacity
  vpc_zone_identifier = var.private_app_subnet_ids

  # Register new instances with the ALB target group
  target_group_arns = [aws_lb_target_group.app.arn]

  # Wait for instances to pass health checks before marking them in-service
  health_check_type         = "ELB"
  health_check_grace_period = 300 # Seconds to wait before first health check

  # Use the latest version of the launch template
  launch_template {
    id      = aws_launch_template.app.id
    version = "$Latest"
  }

  # Ensure new instances are healthy before terminating old ones during updates
  instance_refresh {
    strategy = "Rolling"
    preferences {
      min_healthy_percentage = 50
    }
  }

  tag {
    key                 = "Name"
    value               = "${var.name_prefix}-app-instance"
    propagate_at_launch = true
  }

  lifecycle {
    # Ignore changes to desired_capacity made by scaling policies
    ignore_changes = [desired_capacity]
  }
}

# -----------------------------------------------------------------------------
# Auto Scaling Policy — Scale Out
# Adds one instance when average CPU utilization exceeds 70% for 2 minutes.
# -----------------------------------------------------------------------------
resource "aws_autoscaling_policy" "scale_out" {
  name                   = "${var.name_prefix}-scale-out"
  autoscaling_group_name = aws_autoscaling_group.app.name
  adjustment_type        = "ChangeInCapacity"
  scaling_adjustment     = 1    # Add 1 instance
  cooldown               = 120  # Wait 2 minutes before another scale-out
}

resource "aws_cloudwatch_metric_alarm" "cpu_high" {
  alarm_name          = "${var.name_prefix}-cpu-high"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 60
  statistic           = "Average"
  threshold           = 70
  alarm_description   = "Scale out when average CPU > 70% for 2 minutes"
  alarm_actions       = [aws_autoscaling_policy.scale_out.arn]

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.app.name
  }
}

# -----------------------------------------------------------------------------
# Auto Scaling Policy — Scale In
# Removes one instance when average CPU utilization drops below 30%.
# -----------------------------------------------------------------------------
resource "aws_autoscaling_policy" "scale_in" {
  name                   = "${var.name_prefix}-scale-in"
  autoscaling_group_name = aws_autoscaling_group.app.name
  adjustment_type        = "ChangeInCapacity"
  scaling_adjustment     = -1   # Remove 1 instance
  cooldown               = 300  # Wait 5 minutes before another scale-in
}

resource "aws_cloudwatch_metric_alarm" "cpu_low" {
  alarm_name          = "${var.name_prefix}-cpu-low"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 60
  statistic           = "Average"
  threshold           = 30
  alarm_description   = "Scale in when average CPU < 30% for 2 minutes"
  alarm_actions       = [aws_autoscaling_policy.scale_in.arn]

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.app.name
  }
}
