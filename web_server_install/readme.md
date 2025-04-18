# 🌐 Apache Web Server Installer for Linux

This script helps you **quickly install and configure Apache (httpd)** on most popular Linux distributions. It auto-detects your OS and uses the appropriate package manager and service commands.

---

## ✅ Supported Distros

| Distribution     | Package Manager | Apache Package | Service Name |
|------------------|------------------|----------------|--------------|
| Ubuntu, Debian   | `apt`            | `apache2`      | `apache2`    |
| CentOS, RHEL     | `yum`            | `httpd`        | `httpd`      |
| AlmaLinux, Rocky | `yum`            | `httpd`        | `httpd`      |
| Amazon Linux     | `yum`            | `httpd`        | `httpd`      |
| Fedora           | `dnf`            | `httpd`        | `httpd`      |
| Arch Linux       | `pacman`         | `apache`       | `httpd`      |

---

## 📦 What It Does

- Detects your Linux distribution
- Installs Apache (`apache2` or `httpd`)
- Starts and enables the web server
- Creates a sample `index.html` for testing
- Displays your IP address for access

---

## 🚀 How to Use

### 1. Download and run

```bash
wget https://raw.githubusercontent.com/MinhPhanCoder/AutoHub/refs/heads/master/web_server_install/web_server_install.sh
chmod +x install-httpd.sh
./install-httpd.sh
```

### 2. Stop Ubuntu/Debian:
```
sudo systemctl stop apache2
sudo systemctl disable apache2
```
### 2. Stop CentOS/RHEL/Amazon/Fedora/Arch::
```
sudo systemctl stop httpd
sudo systemctl disable httpd
```