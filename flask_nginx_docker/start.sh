#!/bin/bash

# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'
LINE="==================================="

# Check Docker permissions
check_docker_permissions() {
    if ! docker info >/dev/null 2>&1; then
        echo -e "${YELLOW}⚠️ Docker permission issue detected${NC}"
        sudo chmod 666 /var/run/docker.sock
    fi
}

# Check if domain was provided
if [ -z "$1" ]; then
    echo -e "${RED}❌ Please provide a domain name!"
    echo "Usage: $0 example.com${NC}"
    exit 1
fi

export DOMAIN=$1

echo -e "${GREEN}$LINE"
echo "🚀 Starting Flask API with Let's Encrypt SSL..."
echo "🌐 Domain: $DOMAIN"
echo -e "$LINE${NC}"

# Check permissions before starting
check_docker_permissions

# Create data directories for Let's Encrypt
sudo mkdir -p /etc/letsencrypt
sudo mkdir -p /var/lib/letsencrypt

# Start docker compose
docker-compose down
docker-compose up --build -d

echo -e "${GREEN}$LINE"
echo "✅ System is starting!"
echo "⏳ Waiting for SSL certificate setup..."
echo "🌐 Access the API at: https://$DOMAIN"
echo "📝 API Endpoints:"
echo "  - GET /        - Welcome message"
echo "  - GET /health  - Health check"
echo "  - GET /info    - Application info"
echo -e "$LINE${NC}"