#!/bin/bash

# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'
LINE="==================================="

# Check if domain was provided
if [ -z "$1" ]; then
    echo -e "${RED}❌ Please provide a domain name!"
    echo "Usage: $0 example.com${NC}"
    exit 1
fi

DOMAIN=$1

# Update Nginx config
echo -e "${GREEN}🔧 Updating Nginx configuration for $DOMAIN...${NC}"
sed -i "s/server_name localhost;/server_name $DOMAIN;/g" nginx.conf

# Update Dockerfile.nginx
echo -e "${GREEN}🔧 Updating SSL certificate configuration...${NC}"
sed -i "s/CN=localhost/CN=$DOMAIN/g" Dockerfile.nginx

echo -e "${GREEN}$LINE"
echo "✅ Domain configuration updated!"
echo "🔄 Please rebuild and restart containers:"
echo "docker-compose up --build -d"
echo -e "$LINE${NC}"