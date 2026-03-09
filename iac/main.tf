provider "aws" {
  region = "us-east-1"
}

resource "aws_security_group" "web_sg" {
name = "webplatform-sg"
description = "Allow HTTP and SSH"

ingress {
from_port = 22
to_port = 22
protocol = "tcp"
cidr_blocks = ["0.0.0.0/0"]
}

ingress {
from_port = 80
to_port = 80
protocol = "tcp"
cidr_blocks = ["0.0.0.0/0"]
}

ingress {
from_port = 443
to_port = 443
protocol = "tcp"
cidr_blocks = ["0.0.0.0/0"]
}

egress {
from_port = 0
to_port = 0
protocol = "-1"
cidr_blocks = ["0.0.0.0/0"]
}
}

resource "aws_instance" "web" {
ami                         = "ami-053b0d53c279acc90" # Ubuntu 22.04 (ejemplo)
instance_type               = "t3.micro"
key_name                    = "webplatform-key"
vpc_security_group_ids      = [aws_security_group.web_sg.id]

iam_instance_profile        = aws_iam_instance_profile.ec2_profile.name

user_data                   = file("${path.module}/../scripts/user_data.sh")
user_data_replace_on_change = true

tags = {
Name = "webplatform-server"
}
}