#!/bin/bash
set -e
cd /home/ubuntu/Web_Platform
# Forzar la descarga de las nuevas imágenes de ECR antes de levantar
docker compose -f docker/docker-compose.prod.yml pull
docker compose -f docker/docker-compose.prod.yml up -d
