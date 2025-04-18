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

install_git() {
    echo -e "${GREEN}📦 Installing Git on $DISTRO...${NC}"
    case "$DISTRO" in
        ubuntu|debian)
            sudo apt update -y
            sudo apt install -y git
            ;;
        centos|rhel|rocky|almalinux)
            sudo yum install -y git
            ;;
        fedora)
            sudo dnf install -y git
            ;;
        amzn)
            sudo yum install -y git
            ;;
        arch)
            sudo pacman -Sy --noconfirm git
            ;;
        *)
            echo -e "${RED}❌ Unsupported distro: $DISTRO${NC}"
            exit 1
            ;;
    esac
}

configure_git() {
    echo -e "${GREEN}🔧 Would you like to configure Git with your name and email? (y/n)${NC}"
    read -r configure

    if [[ $configure =~ ^[Yy]$ ]]; then
        echo -e "${GREEN}Enter your name:${NC}"
        read -r git_name
        echo -e "${GREEN}Enter your email:${NC}"
        read -r git_email
        
        git config --global user.name "$git_name"
        git config --global user.email "$git_email"
        
        echo -e "${GREEN}✨ Git configured successfully!${NC}"
    fi
}

# Main
echo -e "${GREEN}$LINE"
echo "🚀 Starting Git installation..."
echo -e "$LINE${NC}"

detect_os
install_git
configure_git

# Verify installation
echo -e "${GREEN}$LINE"
echo "✅ Git version:"
git --version
echo "🎉 Git installation completed successfully!"
echo -e "$LINE${NC}"