#!/bin/bash

set -e
exec > /home/ubuntu/userdata.log 2>&1

export DEBIAN_FRONTEND=noninteractive

apt update -y
apt install -y docker.io docker-compose-plugin unzip curl awscli

systemctl enable docker
systemctl start docker

usermod -aG docker ubuntu
mkdir -p /home/ubuntu/Web_Platform/docker
chown -R ubuntu:ubuntu /home/ubuntu/Web_Platform

cat << 'EOF' > /home/ubuntu/Web_Platform/deploy.sh
#!/bin/bash
set -e

cd /home/ubuntu/Web_Platform

aws s3 cp s3://webplatform-secrets-prod/prod.env docker/.env
chmod 600 docker/.env

ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)

aws ecr get-login-password --region us-east-1 \
| docker login --username AWS --password-stdin ${ACCOUNT_ID}.dkr.ecr.us-east-1.amazonaws.com

docker pull ${ACCOUNT_ID}.dkr.ecr.us-east-1.amazonaws.com/nextcloud-app:nextcloud-latest
docker pull ${ACCOUNT_ID}.dkr.ecr.us-east-1.amazonaws.com/nextcloud-app:nginx-latest

cd docker
docker compose -f docker-compose.prod.yml up -d
EOF

chmod +x /home/ubuntu/Web_Platform/deploy.sh
chown ubuntu:ubuntu /home/ubuntu/Web_Platform/deploy.sh