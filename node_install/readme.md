# 🟢 Node.js & NVM Installer

Automated script to install Node.js and NVM (Node Version Manager) on Linux systems.

## ✨ Features

- Automatic OS detection and package manager selection
- NVM installation and configuration
- Latest LTS Node.js installation
- Yarn package manager installation
- NPM auto-update to latest version
- Shell configuration (.bashrc/.zshrc) setup
- Supports multiple Linux distributions:
  - Ubuntu/Debian
  - CentOS/RHEL/Rocky/AlmaLinux
  - Fedora
  - Amazon Linux
  - Arch Linux

## 🔧 Requirements

- Root/sudo privileges
- Internet connection
- One of the supported Linux distributions
- curl installed (script will install if missing)

## 🚀 Usage

### 1. Download
```bash
wget https://raw.githubusercontent.com/MinhPhanCoder/AutoHub/refs/heads/master/node_install/node_install.sh
chmod +x node_install.sh
```

### 2. Install
```bash
./node_install.sh
```

### 3. Verify
After restarting your terminal or running `source ~/.bashrc`:
```bash
node --version
npm --version
yarn --version
nvm --version
```

## 🔄 Managing Node.js Versions

### List available versions:
```bash
nvm ls-remote
```

### Install specific version:
```bash
nvm install 16.14.0  # Example version
```

### Switch versions:
```bash
nvm use 16.14.0  # Switch to specific version
nvm use --lts    # Switch to LTS version
```

### Set default version:
```bash
nvm alias default 16.14.0  # Example version
nvm alias default node     # Use latest version
```

## ❌ Uninstall

### Remove Node.js & global packages:
```bash
nvm deactivate
nvm uninstall $(nvm current)
```

### Remove NVM completely:
```bash
rm -rf "$HOME/.nvm"

# Remove NVM entries from shell RC file:
sed -i '/NVM_DIR/d' ~/.bashrc  # For bash
# OR
sed -i '/NVM_DIR/d' ~/.zshrc   # For zsh
```

### Remove build dependencies:
```bash
# For Ubuntu/Debian
sudo apt remove -y build-essential
sudo apt autoremove -y

# For CentOS/RHEL/Rocky/AlmaLinux/Fedora
sudo yum groupremove -y 'Development Tools'

# For Arch Linux
sudo pacman -R base-devel
```

## ⚠️ Troubleshooting

### NVM not found after installation:
```bash
source ~/.bashrc  # For bash users
# OR
source ~/.zshrc   # For zsh users
```

### Permission errors with global packages:
1. Don't use sudo with npm
2. Reinstall Node.js with NVM
```bash
nvm reinstall-packages $(nvm current)
```