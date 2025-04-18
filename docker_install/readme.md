# 🐳 Docker & Docker Compose Installer

Automated script to install Docker and Docker Compose on Linux systems.

## ✨ Features

- Automatic OS detection and package manager selection
- Docker CE installation and configuration
- Latest Docker Compose installation
- Automatic service startup
- Supports multiple Linux distributions:
  - Ubuntu/Debian
  - CentOS/RHEL/Rocky/AlmaLinux
  - Fedora

## 🔧 Requirements

- Root/sudo privileges
- Internet connection
- One of the supported Linux distributions

## 🚀 Usage

### 1. Download
```bash
wget https://raw.githubusercontent.com/MinhPhanCoder/AutoHub/refs/heads/master/docker_install/docker_install.sh
chmod +x docker_install.sh
```

### 2. Install
```bash
./docker_install.sh
```

### 3. Verify
```bash
docker --version
docker-compose --version
docker run hello-world
```

## ❌ Uninstall
```bash
# For Ubuntu/Debian
sudo apt remove docker-ce docker-ce-cli containerd.io -y
sudo apt autoremove -y
sudo rm -rf /var/lib/docker
sudo rm -rf /var/lib/containerd

# For CentOS/RHEL/Rocky/AlmaLinux/Fedora
sudo yum remove docker-ce docker-ce-cli containerd.io -y
sudo rm -rf /var/lib/docker
sudo rm -rf /var/lib/containerd

# Remove Docker Compose
sudo rm /usr/local/bin/docker-compose
```