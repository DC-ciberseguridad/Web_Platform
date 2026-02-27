provider "aws" {
  region = "us-east-1"
}

# ===============================
# AMI Ubuntu 22.04
# ===============================

data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }
}

# ===============================
# ECR Repository (ÚNICO)
# ===============================

resource "aws_ecr_repository" "nextcloud" {
  name = "nextcloud-app"
}

# ===============================
# Security Group
# ===============================

resource "aws_security_group" "ec2_sg" {
  name = "nextcloud-sg"

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "SSH from my IP"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.my_ip
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# ===============================
# IAM ROLE para EC2
# ===============================

resource "aws_iam_role" "ec2_role" {
  name = "webplatform-ec2-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
    }]
  })
}

# ===============================
# IAM POLICY (ECR Pull + S3)
# ===============================

resource "aws_iam_policy" "ec2_policy" {
  name = "webplatform-ec2-policy"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [

      {
        Effect = "Allow"
        Action = [
          "ecr:GetAuthorizationToken",
          "ecr:BatchCheckLayerAvailability",
          "ecr:GetDownloadUrlForLayer",
          "ecr:BatchGetImage"
        ]
        Resource = "*"
      },

      {
        Effect = "Allow"
        Action = [
          "s3:GetObject"
        ]
        Resource = "arn:aws:s3:::webplatform-secrets-prod/*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "attach_policy" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = aws_iam_policy.ec2_policy.arn
}

resource "aws_iam_instance_profile" "ec2_profile" {
  name = "webplatform-ec2-profile"
  role = aws_iam_role.ec2_role.name
}

# ===============================
# EC2
# ===============================

resource "aws_instance" "nextcloud" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = "t3.micro"
  key_name               = "webplatform-key"
  vpc_security_group_ids = [aws_security_group.ec2_sg.id]
  iam_instance_profile   = aws_iam_instance_profile.ec2_profile.name

  user_data = file("${path.module}/../scripts/user_data.sh")

  tags = {
    Name = "Nextcloud-Server"
  }
}

# ===============================
# Outputs
# ===============================

output "public_ip" {
  value = aws_instance.nextcloud.public_ip
}