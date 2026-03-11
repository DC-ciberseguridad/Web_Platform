#!/bin/bash

apt-get update
apt-get install -y docker.io docker-compose-plugin awscli
systemctl start docker
systemctl enable docker

# Agregar al usuario ubuntu al grupo docker para evitar usar sudo
usermod -aG docker ubuntu