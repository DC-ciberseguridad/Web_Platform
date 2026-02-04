output "ec2_public_ip" {
  description = "Public IP of EC2"
  value       = aws_instance.web.public_ip
}

output "ecr_repository_url" {
  description = "ECR repository URL"
  value       = aws_ecr_repository.fastapi.repository_url
}