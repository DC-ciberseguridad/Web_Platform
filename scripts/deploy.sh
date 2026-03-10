#!/bin/bash
set -e

# Ir al directorio del proyecto
cd /home/ubuntu/Web_Platform

# 1. Obtener dinámicamente el ID de la cuenta de AWS y la región
AWS_REGION="us-east-1"
AWS_ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)
ECR_URL="${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com"

echo "Autenticando en ECR: ${ECR_URL}..."

# 2. Autenticar Docker con ECR usando el IAM Role de la EC2
aws ecr get-login-password --region ${AWS_REGION} | docker login --username AWS --password-stdin ${ECR_URL}

# 3. Descargar las imágenes nuevas (Pull)
# Asegúrate de que tu docker-compose.prod.yml use la variable ${ECR_REGISTRY}
docker compose -f docker/docker-compose.prod.yml pull

# 4. Levantar los servicios (recreando solo lo necesario)
docker compose -f docker/docker-compose.prod.yml up -d --remove-orphans
