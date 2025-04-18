#!/bin/bash

# Exit on error
set -e

# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'
LINE="==================================="

# Detect OS
detect_os() {
    if [ -f /etc/os-release ]; then
        source /etc/os-release
        DISTRO=$ID
    else
        echo -e "${RED}❌ Cannot detect Linux distribution.${NC}"
        exit 1
    fi
}

install_nginx() {
    echo -e "${GREEN}📦 Installing Nginx on $DISTRO...${NC}"
    case "$DISTRO" in
        ubuntu|debian)
            sudo apt update -y
            sudo apt install -y nginx
            ;;
        centos|rhel|rocky|almalinux)
            sudo yum install -y epel-release
            sudo yum install -y nginx
            ;;
        fedora)
            sudo dnf install -y nginx
            ;;
        amzn)
            sudo amazon-linux-extras install -y nginx1
            ;;
        *)
            echo -e "${RED}❌ Unsupported distro: $DISTRO${NC}"
            exit 1
            ;;
    esac

    # Start and enable Nginx
    sudo systemctl start nginx
    sudo systemctl enable nginx
}

install_certbot() {
    echo -e "${GREEN}📦 Installing Certbot...${NC}"
    case "$DISTRO" in
        ubuntu|debian)
            sudo apt install -y certbot python3-certbot-nginx
            ;;
        centos|rhel|rocky|almalinux|fedora)
            sudo yum install -y certbot python3-certbot-nginx
            ;;
        amzn)
            sudo yum install -y python3 augeas-libs
            sudo python3 -m pip install --upgrade pip
            sudo python3 -m pip install certbot certbot-nginx
            ;;
        *)
            echo -e "${RED}❌ Unsupported distro: $DISTRO${NC}"
            exit 1
            ;;
    esac
}

check_dns() {
    local domain=$1
    local server_ip=$(curl -s ifconfig.me)
    echo -e "✅✅✅Your VM public IP: $server_ip✅✅✅"
    echo -e "${YELLOW}🔍 Checking DNS records for $domain...${NC}"
    
    # Install dig if not present
    case "$DISTRO" in
        ubuntu|debian)
            if ! command -v dig &> /dev/null; then
                sudo apt update -y
                sudo apt install -y dnsutils
            fi
            ;;
        centos|rhel|rocky|almalinux|fedora|amzn)
            if ! command -v dig &> /dev/null; then
                sudo yum install -y bind-utils
            fi
            ;;
    esac

    # Get domain's IP
    local domain_ip=$(dig +short "$domain" | grep -E '^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$' | head -n 1)
    local www_domain_ip=$(dig +short "www.$domain" | grep -E '^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$' | head -n 1)

    if [ -z "$domain_ip" ]; then
        echo -e "${RED}❌ No A record found for $domain${NC}"
        echo -e "${YELLOW}ℹ️  Please add these DNS records:${NC}"
        echo -e "   $domain       A   $server_ip"
        echo -e "   www.$domain   A   $server_ip"
        return 1
    fi

    if [ -z "$www_domain_ip" ]; then
        echo -e "${RED}❌ No A record found for www.$domain${NC}"
        echo -e "${YELLOW}ℹ️  Please add these DNS records:${NC}"
        echo -e "   $domain       A   $server_ip"
        echo -e "   www.$domain   A   $server_ip"
        return 1
    fi

    if [ "$domain_ip" != "$server_ip" ]; then
        echo -e "${RED}❌ Domain $domain is pointing to $domain_ip instead of $server_ip${NC}"
        return 1
    fi

    if [ "$www_domain_ip" != "$server_ip" ]; then
        echo -e "${RED}❌ Domain www.$domain is pointing to $www_domain_ip instead of $server_ip${NC}"
        return 1
    fi

    echo -e "${GREEN}✅ DNS records are correctly configured!${NC}"
    return 0
}

wait_for_dns() {
    local domain=$1
    local max_attempts=5
    local attempt=1

    while [ $attempt -le $max_attempts ]; do
        echo -e "${YELLOW}🕒 Attempt $attempt of $max_attempts to verify DNS...${NC}"
        
        if check_dns "$domain"; then
            return 0
        fi

        if [ $attempt -lt $max_attempts ]; then
            echo -e "${YELLOW}⏳ Waiting 30 seconds before next check...${NC}"
            sleep 30
        fi
        
        attempt=$((attempt + 1))
    done

    echo -e "${RED}❌ DNS verification failed after $max_attempts attempts.${NC}"
    echo -e "${YELLOW}Please ensure your DNS records are properly configured and try again.${NC}"
    exit 1
}

configure_nginx() {
    local domain=$1
    echo -e "${GREEN}🔧 Configuring Nginx for $domain...${NC}"
    
    # Basic Nginx config
    cat > /tmp/nginx.conf << EOF
server {
    listen 80;
    server_name $domain www.$domain;
    root /var/www/$domain;
    index index.html;

    location / {
        try_files \$uri \$uri/ =404;
    }
}
EOF

    # Create web root directory
    sudo mkdir -p /var/www/$domain
    
    # Create sample index.html
    cat > /tmp/index.html << EOF
<!DOCTYPE html>
<html>
<head>
    <title>Welcome to $domain!</title>
    <style>
        body { 
            font-family: Arial, sans-serif;
            text-align: center;
            padding: 50px;
        }
        h1 { color: #0066cc; }
    </style>
</head>
<body>
    <h1>Welcome to $domain!</h1>
    <p>This site is secured with Let's Encrypt SSL.</p>
</body>
</html>
EOF

    # Move files to their locations
    sudo mv /tmp/nginx.conf /etc/nginx/conf.d/$domain.conf
    sudo mv /tmp/index.html /var/www/$domain/index.html

    # Test Nginx configuration
    sudo nginx -t

    # Reload Nginx
    sudo systemctl reload nginx
}

setup_ssl() {
    local domain=$1
    echo -e "${GREEN}🔒 Setting up SSL for $domain...${NC}"
    
    # Get SSL certificate
    sudo certbot --nginx --non-interactive --agree-tos --email admin@$domain \
        --redirect --hsts --staple-ocsp \
        -d $domain -d www.$domain

    # Setup auto renewal
    echo "0 0,12 * * * root python3 -c 'import random; import time; time.sleep(random.random() * 3600)' && certbot renew -q" | sudo tee -a /etc/crontab > /dev/null
}

# Main
echo -e "${GREEN}$LINE"
echo "🌐 Nginx & SSL Installation Script"
echo -e "$LINE${NC}"

# Check if domain was provided
if [ -z "$1" ]; then
    echo -e "${RED}❌ Please provide a domain name!"
    echo "Usage: $0 example.com${NC}"
    exit 1
fi

DOMAIN=$1

detect_os
install_nginx
install_certbot

echo -e "${YELLOW}$LINE"
echo "⚠️  Before proceeding, please ensure you have configured your DNS records:"
echo "   $DOMAIN       A   $(curl -s ifconfig.me)"
echo "   www.$DOMAIN   A   $(curl -s ifconfig.me)"
echo -e "$LINE${NC}"

read -p "Press Enter when you have configured your DNS records..."

wait_for_dns $DOMAIN
configure_nginx $DOMAIN
setup_ssl $DOMAIN

echo -e "${GREEN}$LINE"
echo "✅ Installation Complete!"
echo "🌐 Your website is ready at: https://$DOMAIN"
echo "📂 Website root: /var/www/$DOMAIN"
echo "📝 Nginx config: /etc/nginx/conf.d/$DOMAIN.conf"
echo -e "$LINE${NC}"