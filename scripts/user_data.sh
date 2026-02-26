#!/bin/bash

apt update -y
apt install -y awscli
apt install -y docker.io docker-compose-plugin

systemctl enable docker
systemctl start docker

usermod -aG docker ubuntu

# Crear estructura del proyecto
mkdir -p /home/ubuntu/Web_Platform/docker

# Crear deploy.sh automáticamente
cat << 'EOF' > /home/ubuntu/Web_Platform/deploy.sh
#!/bin/bash

cd /home/ubuntu/Web_Platform

aws s3 cp s3://webplatform-secrets-prod/prod.env docker/.env
chmod 600 docker/.env

aws ecr get-login-password --region us-east-1 \
| docker login --username AWS --password-stdin 838054320781.dkr.ecr.us-east-1.amazonaws.com

docker pull 838054320781.dkr.ecr.us-east-1.amazonaws.com/nextcloud-app:latest

cd docker
docker compose -f docker-compose.prod.yml up -d
EOF

chmod +x /home/ubuntu/Web_Platform/deploy.sh
chown ubuntu:ubuntu /home/ubuntu/Web_Platform/deploy.sh
