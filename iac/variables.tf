variable "aws_region" {
  description = "AWS region where infrastructure will be deployed"
  type        = string
  default     = "us-east-1"
}

variable "ssh_public_key" {
  description = "Public SSH key used to access the EC2 instance"
  type        = string
}

variable "allowed_ssh_ips" {
  description = "List of CIDR blocks allowed to access EC2 via SSH"
  type        = list(string)

  # EJEMPLO:
  # ["190.123.45.67/32"]
}

