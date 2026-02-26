output "ec2_public_ip" {
  value = aws_instance.nextcloud.public_ip
}

output "ecr_repository_url" {
  value = aws_ecr_repository.nextcloud.repository_url
}
