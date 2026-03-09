#para que terraform exponga la IP publica del host
output "ec2_public_ip" {
  value = aws_instance.web.public_ip
}

#para que terraform exponga la URL del ECR
output "ecr_repository_url" {
  value = aws_ecr_repository.nextcloud.repository_url
}

output "security_group_id" {
  value = aws_security_group.web_sg.id
}
