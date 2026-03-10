#para que terraform exponga la IP publica del host
output "ec2_public_ip" {
  value = aws_instance.web.public_ip
}

# Para obtener la URL del repo de Nextcloud
output "ecr_nextcloud_url" {
  value = aws_ecr_repository.nextcloud.repository_url
}

# Para obtener la URL del repo de Nginx
output "ecr_nginx_url" {
  value = aws_ecr_repository.nextcloud_nginx.repository_url
}

output "security_group_id" {
  value = aws_security_group.web_sg.id
}
