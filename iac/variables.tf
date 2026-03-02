variable "my_ip" {
  description = "List of CIDR blocks allowed to access EC2 via SSH"
  type        = list(string)

  # EJEMPLO:
  # ["190.123.45.67/32"]
}

variable "ssh_public_key" {
  description = "SSH public key for EC2 access"
  type        = string
  
}
