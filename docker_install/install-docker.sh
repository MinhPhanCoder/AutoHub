#!/bin/bash

set -e  # Exit ngay khi gặp lỗi

echo "🔧 Installing dependencies..."
sudo apt update -y
sudo apt install -y apt-transport-https ca-certificates curl software-properties-common gnupg lsb-release

echo "🔐 Adding Docker GPG key..."
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | \
  sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

echo "📦 Adding Docker repository..."
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] \
  https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

echo "🔄 Updating package index..."
sudo apt update -y

echo "🐳 Installing Docker CE..."
sudo apt install -y docker-ce docker-ce-cli containerd.io

echo "🚀 Starting Docker..."
sudo systemctl start docker
sudo systemctl enable docker

echo "🔧 Installing Docker Compose..."
DOCKER_COMPOSE_VERSION=$(curl -s https://api.github.com/repos/docker/compose/releases/latest | grep tag_name | cut -d '"' -f 4)
sudo curl -L "https://github.com/docker/compose/releases/download/${DOCKER_COMPOSE_VERSION}/docker-compose-$(uname -s)-$(uname -m)" \
  -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

echo "✅ Docker version:"
docker -v

echo "✅ Docker Compose version:"
docker-compose -v
echo "🎉 Docker and Docker Compose installation completed successfully!"