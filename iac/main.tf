provider "aws" {
  region = "us-east-1"
}

# 1. ECR Repository - Repositorio para Nextcloud
resource "aws_ecr_repository" "nextcloud" {
  name                 = "nextcloud-app"
  force_delete         = true # Útil para que Terraform pueda borrarlo aunque tenga imágenes
}

# Repositorio para Nginx 
resource "aws_ecr_repository" "nextcloud_nginx" {
  name                 = "nextcloud-nginx"
  force_delete         = true
}

# 2. IAM Role, Policy y Profile
resource "aws_iam_role" "ec2_role" {
  name = "webplatform-ec2-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = { Service = "ec2.amazonaws.com" }
    }]
  })
}

resource "aws_iam_policy" "ec2_policy" {
  name = "webplatform-ec2-policy"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Action = [
        "ecr:GetAuthorizationToken",
        "ecr:BatchCheckLayerAvailability",
        "ecr:GetDownloadUrlForLayer",
        "ecr:BatchGetImage"
      ]
      Resource = "*"
    }]
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

# 3. Security Group
resource "aws_security_group" "web_sg" {
  name        = "webplatform-sg"
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.my_ip
  }
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# 4. EC2 key pair
resource "aws_key_pair" "webplatform" {
  key_name   = "webplatform-key"
  public_key = var.ssh_public_key
}

# 5. EC2 Instance
resource "aws_instance" "web" {
  ami                         = "ami-053b0d53c279acc90"
  instance_type               = "t3.micro"
  key_name                    = "webplatform-key"
  vpc_security_group_ids      = [aws_security_group.web_sg.id]
  iam_instance_profile        = aws_iam_instance_profile.ec2_profile.name
  user_data                   = file("${path.module}/../scripts/user_data.sh")
  user_data_replace_on_change = true
  tags = { Name = "webplatform-server" }
}