# 📦 Git Installer

Automated script to install and configure Git on Linux systems.

## ✨ Features

- Automatic OS detection and package manager selection
- Git installation and basic configuration
- Interactive setup for user.name and user.email
- Supports multiple Linux distributions:
  - Ubuntu/Debian
  - CentOS/RHEL/Rocky/AlmaLinux
  - Fedora
  - Arch Linux

## 🔧 Requirements

- Root/sudo privileges
- Internet connection
- One of the supported Linux distributions

## 🚀 Usage

### 1. Download
```bash
wget https://raw.githubusercontent.com/MinhPhanCoder/AutoHub/refs/heads/master/git_install/git_install.sh
chmod +x git_install.sh
```

### 2. Install
```bash
./git_install.sh
```

### 3. Verify
```bash
git --version
git config --list
```

## ❌ Uninstall
```bash
# For Ubuntu/Debian
sudo apt remove git -y
sudo apt autoremove -y

# For CentOS/RHEL/Rocky/AlmaLinux/Fedora
sudo yum remove git -y

# For Arch Linux
sudo pacman -R git

# Remove global Git configuration
rm -f ~/.gitconfig
```