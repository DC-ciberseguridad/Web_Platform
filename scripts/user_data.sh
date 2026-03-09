
#!/bin/bash

apt update -y
apt upgrade -y
apt install -y docker.io docker-compose-plugin unzip curl git

systemctl enable docker
systemctl start docker
usermod -aG docker ubuntu

#==================================================

mkdir -p /home/ubuntu/Web_Platform
chown -R ubuntu:ubuntu /home/ubuntu/Web_Platform