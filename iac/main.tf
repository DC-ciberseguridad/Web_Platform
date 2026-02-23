provider "aws" {
  region = var.aws_region
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
# ECR Repository
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
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.my_ip]
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
# IAM POLICY (S3 + ECR)
# ===============================

resource "aws_iam_policy" "ec2_app_policy" {
  name = "webplatform-ec2-app-policy"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [

      # S3 Secrets
      {
        Effect = "Allow"
        Action = [
          "s3:GetObject"
        ]
        Resource = "arn:aws:s3:::webplatform-secrets-prod/*"
      },

      # ECR Pull Permissions
      {
        Effect = "Allow"
        Action = [
          "ecr:GetAuthorizationToken",
          "ecr:BatchCheckLayerAvailability",
          "ecr:GetDownloadUrlForLayer",
          "ecr:BatchGetImage"
        ]
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "attach_app_policy" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = aws_iam_policy.ec2_app_policy.arn
}

# ===============================
# Instance Profile
# ===============================

resource "aws_iam_instance_profile" "ec2_profile" {
  name = "webplatform-ec2-profile"
  role = aws_iam_role.ec2_role.name
}

# ===============================
# EC2 INSTANCE
# ===============================

resource "aws_instance" "nextcloud" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = "t3.micro"
  key_name               = var.key_name
  vpc_security_group_ids = [aws_security_group.ec2_sg.id]

  iam_instance_profile = aws_iam_instance_profile.ec2_profile.name

  user_data = file("${path.module}/../scripts/user_data.sh")

  tags = {
    Name = "Nextcloud-Server"
  }
}
