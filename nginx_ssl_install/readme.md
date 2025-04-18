# 🌐 Nginx & SSL Installer

Automated script to install and configure Nginx web server with Let's Encrypt SSL certificates.

## ✨ Features

- Automatic OS detection and package manager selection
- Nginx installation and configuration
- Let's Encrypt SSL certificate setup via Certbot
- Automatic SSL renewal
- WWW subdomain support (www.yourdomain.com)
- HTTPS redirect
- HSTS enabled
- OCSP stapling
- Supports multiple Linux distributions:
  - Ubuntu/Debian
  - CentOS/RHEL/Rocky/AlmaLinux
  - Fedora
  - Amazon Linux

## 🔧 Requirements

- Root/sudo privileges
- Internet connection
- Domain name with DNS A records pointing to your server
- One of the supported Linux distributions
- Port 80 and 443 open in firewall

## 🚀 Usage

### 1. Download
```bash
wget https://raw.githubusercontent.com/MinhPhanCoder/AutoHub/refs/heads/master/nginx_ssl_install/nginx_ssl_install.sh
chmod +x nginx_ssl_install.sh
```

### 2. Install
```bash
./nginx_ssl_install.sh your-domain.com
```

### 3. Verify
Access your domain:
- HTTP: `http://your-domain.com` (will redirect to HTTPS)
- HTTPS: `https://your-domain.com`

### 4. File Locations
- Website root: `/var/www/your-domain.com/`
- Nginx config: `/etc/nginx/conf.d/your-domain.com.conf`
- SSL certificates: `/etc/letsencrypt/live/your-domain.com/`

## ❌ Uninstall
```bash
# For Ubuntu/Debian
sudo apt remove nginx certbot -y
sudo apt autoremove -y

# For CentOS/RHEL/Rocky/AlmaLinux/Fedora
sudo yum remove nginx certbot -y

# For Amazon Linux
sudo yum remove nginx -y
sudo python3 -m pip uninstall certbot certbot-nginx -y

# Remove configurations and website files
sudo rm -rf /etc/nginx/conf.d/your-domain.com.conf
sudo rm -rf /var/www/your-domain.com
sudo rm -rf /etc/letsencrypt/live/your-domain.com
```

## 🔄 SSL Renewal
SSL certificates will automatically renew every 12 hours (if needed).
To manually renew:
```bash
sudo certbot renew
```