#!/bin/bash

apt update -y
apt install -y docker.io docker-compose-plugin unzip curl

curl -fsSL "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip -q awscliv2.zip
sudo ./aws/install

systemctl enable docker
systemctl start docker

# Crear estructura
sudo mkdir -p /home/ubuntu/Web_Platform/docker

# Dar permisos correctos
sudo chown -R ubuntu:ubuntu /home/ubuntu/Web_Platform

# Crear deploy.sh
cat << 'EOF' > /home/ubuntu/Web_Platform/deploy.sh
#!/bin/bash

cd /home/ubuntu/Web_Platform

# Descargar env
/usr/local/bin/aws s3 cp s3://webplatform-secrets-prod/prod.env docker/.env
chmod 600 docker/.env

# Obtener account ID dinámicamente
ACCOUNT_ID=$(/usr/local/bin/aws sts get-caller-identity --query Account --output text)

/usr/local/bin/aws ecr get-login-password --region us-east-1 \
| docker login --username AWS --password-stdin ${ACCOUNT_ID}.dkr.ecr.us-east-1.amazonaws.com

# Pull imágenes correctas
docker pull ${ACCOUNT_ID}.dkr.ecr.us-east-1.amazonaws.com/nextcloud-app:nextcloud-latest
docker pull ${ACCOUNT_ID}.dkr.ecr.us-east-1.amazonaws.com/nextcloud-app:nginx-latest

cd docker

docker compose -f docker-compose.prod.yml up -d
EOF

chmod +x /home/ubuntu/Web_Platform/deploy.sh
chown ubuntu:ubuntu /home/ubuntu/Web_Platform/deploy.sh

touch /home/ubuntu/USER_DATA_FINISHED