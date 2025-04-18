#!/bin/bash

# Exit on error
set -e

# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
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

install_apache() {
    echo -e "${GREEN}📦 Installing Apache on $DISTRO...${NC}"
    case "$DISTRO" in
        ubuntu|debian)
            sudo apt update -y
            sudo apt install -y apache2
            sudo systemctl enable apache2
            sudo systemctl start apache2
            ;;
        centos|rhel|rocky|almalinux)
            sudo yum install -y httpd
            sudo systemctl enable httpd
            sudo systemctl start httpd
            ;;
        fedora)
            sudo dnf install -y httpd
            sudo systemctl enable httpd
            sudo systemctl start httpd
            ;;
        arch)
            sudo pacman -Sy --noconfirm apache
            sudo systemctl enable httpd
            sudo systemctl start httpd
            ;;
        amzn)
            sudo yum install -y httpd
            sudo systemctl enable httpd
            sudo systemctl start httpd
            ;;
        *)
            echo -e "${RED}❌ Unsupported distro: $DISTRO${NC}"
            exit 1
            ;;
    esac
}

create_test_page() {
    echo -e "${GREEN}📝 Creating index.html test page...${NC}"
    
    HTML_PATH="/var/www/html/index.html"
    if [ ! -d "/var/www/html" ]; then
        sudo mkdir -p /var/www/html
    fi

    echo "<!DOCTYPE html>
<html>
<head><title>Apache Test</title></head>
<body>
<h1 style='color:green;'>Apache is working on $DISTRO!</h1>
<p>Served by $(hostname)</p>
</body>
</html>" | sudo tee "$HTML_PATH" > /dev/null
}

show_access_info() {
    IP=$(hostname -I | awk '{print $1}')
    PUBLIC_IP=$(curl -s ifconfig.me || curl -s https://ipinfo.io/ip)

    echo -e "${GREEN}$LINE"
    echo "✅ Apache installation complete!"
    echo "🌍 Access: http://$IP"
    echo "🌍 Access your site publicly at: http://$PUBLIC_IP"
    echo -e "$LINE${NC}"
}

# Main
echo -e "${GREEN}$LINE"
echo "🌐 Installing Apache (httpd) on your Linux system..."
echo -e "$LINE${NC}"

detect_os
install_apache
create_test_page
show_access_info

echo -e "${GREEN}🎉 Apache is installed and running!${NC}"