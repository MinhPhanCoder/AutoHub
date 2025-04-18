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

install_dependencies() {
    echo -e "${GREEN}📦 Installing dependencies on $DISTRO...${NC}"
    case "$DISTRO" in
        ubuntu|debian)
            sudo apt update -y
            sudo apt install -y curl build-essential
            ;;
        centos|rhel|rocky|almalinux)
            sudo yum groupinstall -y 'Development Tools'
            sudo yum install -y curl
            ;;
        fedora)
            sudo dnf groupinstall -y 'Development Tools'
            sudo dnf install -y curl
            ;;
        amzn)
            sudo yum groupinstall -y 'Development Tools'
            sudo yum install -y curl
            ;;
        arch)
            sudo pacman -Sy --noconfirm base-devel curl
            ;;
        *)
            echo -e "${RED}❌ Unsupported distro: $DISTRO${NC}"
            exit 1
            ;;
    esac
}

install_nvm() {
    echo -e "${GREEN}📦 Installing NVM...${NC}"
    
    # Download and run NVM install script
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash
    
    # Load NVM
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
    
    # Add NVM to shell rc file
    RC_FILE="$HOME/.bashrc"
    if [ -f "$HOME/.zshrc" ]; then
        RC_FILE="$HOME/.zshrc"
    fi
    
    if ! grep -q "NVM_DIR" "$RC_FILE"; then
        echo 'export NVM_DIR="$HOME/.nvm"' >> "$RC_FILE"
        echo '[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm' >> "$RC_FILE"
        echo '[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion' >> "$RC_FILE"
    fi
}

install_node() {
    echo -e "${GREEN}📦 Installing Node.js...${NC}"
    
    # Source NVM
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
    
    # Install latest LTS version
    nvm install --lts
    nvm use --lts
    
    # Install common global packages
    npm install -g yarn
    npm install -g npm@latest
}

show_versions() {
    echo -e "${GREEN}$LINE"
    echo "✅ Installed versions:"
    echo "🟢 Node.js version: $(node -v)"
    echo "📦 NPM version: $(npm -v)"
    echo "🧶 Yarn version: $(yarn -v)"
    echo "📝 NVM version: $(nvm -v)"
    echo -e "$LINE${NC}"
}

# Main
echo -e "${GREEN}$LINE"
echo "🟢 Starting Node.js & NVM installation..."
echo -e "$LINE${NC}"

detect_os
install_dependencies
install_nvm
install_node
show_versions

echo -e "${GREEN}🎉 Installation completed successfully!"
echo -e "📝 Please restart your terminal or run: source ~/.bashrc${NC}"