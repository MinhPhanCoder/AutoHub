# 🌐 Nginx & SSL Installer

Automated script to install and configure Nginx web server with Let's Encrypt SSL certificates.

## ✨ Features

- Automatic OS detection and package manager selection
- DNS record verification before SSL setup
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
  - A record for yourdomain.com
  - A record for www.yourdomain.com
- One of the supported Linux distributions
- Port 80 and 443 open in firewall

## 🚀 Usage

### 1. Download
```bash
wget https://raw.githubusercontent.com/MinhPhanCoder/AutoHub/refs/heads/master/nginx_ssl_install/nginx_ssl_install.sh
chmod +x nginx_ssl_install.sh
```

### 2. Configure DNS
Before running the script, add these DNS A records at your domain registrar:
- yourdomain.com -> your-server-ip
- www.yourdomain.com -> your-server-ip

### 3. Install
```bash
./nginx_ssl_install.sh your-domain.com
```
The script will verify your DNS records and wait if they haven't propagated yet.

### 4. Verify
Access your domain:
- HTTP: `http://your-domain.com` (will redirect to HTTPS)
- HTTPS: `https://your-domain.com`

### 5. File Locations
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

## ⚠️ Troubleshooting

### DNS Issues
If the script shows DNS errors:
1. Verify your A records are correctly set at your domain registrar
2. Wait 5-10 minutes for DNS propagation
3. Run the script again

The script will automatically:
- Check both domain.com and www.domain.com DNS records
- Verify they point to your server's IP
- Retry up to 5 times with 30-second intervals
- Show detailed error messages if something is wrong