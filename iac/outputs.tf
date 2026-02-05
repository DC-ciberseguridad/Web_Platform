output "ecr_repository_url" {
  value = aws_ecr_repository.web_platform.repository_url
}

output "ec2_public_ip" {
  value = aws_instance.web.public_ip
}
