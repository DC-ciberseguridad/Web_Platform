
#!/bin/bash
set -e

exec > /var/log/user-data.log 2>&1
set -x

apt update -y
apt install -y docker.io docker-compose-plugin unzip curl

systemctl enable docker
systemctl start docker
usermod -aG docker ubuntu

# ===== INSTALL AWS CLI V2 CORRECTAMENTE =====
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "/tmp/awscliv2.zip"
unzip -o /tmp/awscliv2.zip -d /tmp
sudo /tmp/aws/install --update

#==================================================

mkdir -p /home/ubuntu/Web_Platform/docker
chown -R ubuntu:ubuntu /home/ubuntu/Web_Platform

cat << 'EOF' > /home/ubuntu/Web_Platform/deploy.sh
#!/bin/bash
set -e

export PATH=$PATH:/usr/bin:/usr/local/bin

cd /home/ubuntu/Web_Platform

/aws s3 cp s3://webplatform-secrets-prod/prod.env docker/.env
chmod 600 docker/.env

ACCOUNT_ID=$(/aws sts get-caller-identity --query Account --output text)

/aws ecr get-login-password --region us-east-1 \
| /usr/bin/docker login --username AWS --password-stdin ${ACCOUNT_ID}.dkr.ecr.us-east-1.amazonaws.com

/usr/bin/docker pull ${ACCOUNT_ID}.dkr.ecr.us-east-1.amazonaws.com/nextcloud-app:nextcloud-latest
/usr/bin/docker pull ${ACCOUNT_ID}.dkr.ecr.us-east-1.amazonaws.com/nextcloud-app:nginx-latest

cd docker
/usr/bin/docker compose -f docker-compose.prod.yml up -d
EOF

chmod +x /home/ubuntu/Web_Platform/deploy.sh
chown ubuntu:ubuntu /home/ubuntu/Web_Platform/deploy.sh