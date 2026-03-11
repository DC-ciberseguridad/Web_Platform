#!/bin/bash
set -e

# Ir al directorio del proyecto
cd /home/ubuntu/Web_Platform

# 1. Login usando el token pasado por el Pipeline
# Si la variable ECR_TOKEN existe, la usamos para loguearnos sin AWS CLI
if [ -n "$ECR_TOKEN" ]; then
    echo "Autenticando en ECR con token del Pipeline..."
    echo "$ECR_TOKEN" | docker login --username AWS --password-stdin "$ECR_REGISTRY"
else
    echo "Error: No se proporcionó ECR_TOKEN"
    exit 1
fi

# 2. Descargar las imágenes nuevas (Pull)
docker compose -f docker/docker-compose.prod.yml pull

# 3. Levantar los servicios (recreando solo lo necesario)
docker compose -f docker/docker-compose.prod.yml up -d --remove-orphans
