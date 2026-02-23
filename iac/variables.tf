variable "aws_region" {
  description = "AWS region where infrastructure will be deployed"
  type        = string
  default     = "us-east-1"
}

variable "my_ip" {
  description = "List of CIDR blocks allowed to access EC2 via SSH"
  type        = string

  # EJEMPLO:
  # ["190.123.45.67/32"]
}
