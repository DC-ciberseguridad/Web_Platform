variable "my_ip" {
  description = "List of CIDR blocks allowed to access EC2 via SSH"
  type        = list(string)
}

variable "ssh_public_key" {
  description = "SSH public key for EC2 access"
  type        = string
  
}