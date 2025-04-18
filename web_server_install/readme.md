# 🌐 Apache Web Server Installer

Automated script to install and configure Apache Web Server on Linux systems.

## ✨ Features

- Automatic OS detection and package manager selection
- Apache installation and auto-start configuration
- Creates a test index.html page
- Shows local and public IP for access
- Supports multiple Linux distributions:
  - Ubuntu/Debian
  - CentOS/RHEL/Rocky/AlmaLinux
  - Amazon Linux
  - Fedora
  - Arch Linux

## 🔧 Requirements

- Root/sudo privileges
- Internet connection
- One of the supported Linux distributions

## 🚀 Usage

### 1. Download
```bash
wget https://raw.githubusercontent.com/MinhPhanCoder/AutoHub/refs/heads/master/web_server_install/web_server_install.sh
chmod +x web_server_install.sh
```

### 2. Install
```bash
./web_server_install.sh
```

### 3. Verify
Access the test page:
- Local: `http://localhost`
- Network: `http://<your-ip>`

## ❌ Uninstall
```bash
# For Ubuntu/Debian
sudo apt remove apache2 -y
sudo apt autoremove -y

# For CentOS/RHEL/Rocky/AlmaLinux/Fedora
sudo yum remove httpd -y

# For Arch Linux
sudo pacman -R apache
```