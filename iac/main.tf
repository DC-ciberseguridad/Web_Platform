terraform {
  backend "s3" {
    bucket  = "terraform-state-webplatform"
    key     = "lab4/infra.tfstate"
    region  = "us-east-1"
    encrypt = true
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

############################
# AMI Ubuntu 22.04 LTS
############################
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }
}

############################
# IAM ROLE (ECR PULL)
############################
resource "aws_iam_role" "ec2_role" {
  name = "web-platform-ec2-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect    = "Allow"
      Principal = { Service = "ec2.amazonaws.com" }
      Action    = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "ecr_pull" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}

resource "aws_iam_instance_profile" "ec2_profile" {
  name = "web-platform-ec2-profile"
  role = aws_iam_role.ec2_role.name
}

############################
# ECR (UN SOLO REPO)
############################
resource "aws_ecr_repository" "web_platform" {
  name                 = "web-platform"
  image_tag_mutability = "IMMUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}

############################
# SSH KEY
############################
resource "aws_key_pair" "deploy" {
  key_name   = "web-deploy-key"
  public_key = var.ssh_public_key
}

############################
# SECURITY GROUP (LIMPIO)
############################
resource "aws_security_group" "web_sg" {
  name = "Web_Platform"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name       = "Web_Platform"
    ManagedBy = "terraform"
  }
}

resource "aws_security_group_rule" "ssh" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = var.allowed_ssh_ips
  security_group_id = aws_security_group.web_sg.id
}

resource "aws_security_group_rule" "http" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.web_sg.id
}

############################
# EC2
############################
resource "aws_instance" "web" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = "t3.micro"
  key_name               = aws_key_pair.deploy.key_name
  vpc_security_group_ids = [aws_security_group.web_sg.id]

  iam_instance_profile = aws_iam_instance_profile.ec2_profile.name

  user_data = <<-EOF
#!/bin/bash
set -eux

apt-get update -y
apt-get install -y docker.io awscli

systemctl enable docker
systemctl start docker

usermod -aG docker ubuntu
EOF

  user_data_replace_on_change = false

  tags = {
    Name = "Web_Platform"
  }
}
