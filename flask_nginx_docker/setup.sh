#!/bin/bash

# Exit on error
set -e

# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'
LINE="==================================="

# Check arguments
if [ -z "$1" ]; then
    echo -e "${RED}❌ Please provide a domain name"
    echo -e "Usage: $0 yourdomain.com${NC}"
    exit 1
fi

DOMAIN=$1
SERVER_IP=$(curl -s ifconfig.me)

# Function to check DNS records
check_dns() {
    local domain=$1
    echo -e "${YELLOW}🔍 Checking DNS records for $domain...${NC}"
    
    local domain_ip=$(dig +short "$domain" | grep -E '^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$' | head -n 1)
    local www_domain_ip=$(dig +short "www.$domain" | grep -E '^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$' | head -n 1)

    if [[ -z "$domain_ip" || -z "$www_domain_ip" || 
          "$domain_ip" != "$SERVER_IP" || "$www_domain_ip" != "$SERVER_IP" ]]; then
        echo -e "${RED}❌ DNS records are not correctly configured!"
        echo -e "${YELLOW}Please configure these A records:${NC}"
        echo -e "   $domain       A   $SERVER_IP"
        echo -e "   www.$domain   A   $SERVER_IP"
        return 1
    fi

    echo -e "${GREEN}✅ DNS records are correctly configured!${NC}"
    return 0
}

# Function to wait for DNS propagation
wait_for_dns() {
    local max_attempts=5
    local attempt=1

    echo -e "${YELLOW}Please configure your DNS records and press Enter when ready...${NC}"
    read -p ""

    while [ $attempt -le $max_attempts ]; do
        echo -e "${YELLOW}🕒 DNS check attempt $attempt of $max_attempts...${NC}"
        
        if check_dns "$DOMAIN"; then
            return 0
        fi

        if [ $attempt -lt $max_attempts ]; then
            echo -e "${YELLOW}⏳ Waiting 30 seconds before next check...${NC}"
            sleep 30
        fi
        
        attempt=$((attempt + 1))
    done

    echo -e "${RED}❌ DNS verification failed. Please check your DNS configuration.${NC}"
    exit 1
}

# Setup directories and configurations
setup_environment() {
    echo -e "${GREEN}📁 Setting up environment...${NC}"
    
    # Create required directories
    mkdir -p ./certbot/conf
    mkdir -p ./certbot/www
    mkdir -p ./nginx/conf
    mkdir -p ./nginx/www
    
    # Configure Nginx
    cp ./nginx/conf/app.conf.template ./nginx/conf/app.conf
    sed -i "s/DOMAIN_NAME/$DOMAIN/g" ./nginx/conf/app.conf

    # Start nginx first
    docker-compose up -d nginx
    
    # Wait for nginx to start
    echo -e "${YELLOW}⏳ Waiting for Nginx to start...${NC}"
    sleep 5
}

# Setup SSL certificates
setup_ssl() {
    echo -e "${GREEN}🔒 Setting up SSL...${NC}"

    # Request Let's Encrypt certificate using webroot plugin
    docker-compose run --rm --entrypoint "\
        certbot certonly --webroot \
        --webroot-path=/var/www/certbot \
        --non-interactive \
        --agree-tos \
        --email admin@${DOMAIN} \
        --preferred-challenges=http \
        --hsts \
        --staple-ocsp \
        -d ${DOMAIN} \
        -d www.${DOMAIN}" certbot

    # Reload nginx to apply new SSL config
    docker-compose exec nginx nginx -s reload
}

# Main execution
echo -e "${GREEN}$LINE"
echo "🚀 Starting Flask + Nginx + SSL setup for $DOMAIN"
echo -e "$LINE${NC}"

wait_for_dns
setup_environment
setup_ssl

echo -e "${GREEN}$LINE"
echo "✅ Setup completed successfully!"
echo "🌐 Your site will be available at: https://$DOMAIN"
echo "📝 Configuration files are in docker volumes"
echo -e "$LINE${NC}"

# Start all services
docker-compose up -d