variable "aws_region" {
  description = "AWS region where infrastructure will be deployed"
  type        = string
  default     = "us-east-1"
}

variable "key_name" {
  description = "EC2 SSH Key name"
  type        = string
}

variable "my_ip" {
  description = "List of CIDR blocks allowed to access EC2 via SSH"
  type        = string

  # EJEMPLO:
  # ["190.123.45.67/32"]
}
