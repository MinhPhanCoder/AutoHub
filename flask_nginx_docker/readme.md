# 🚀 Flask + Nginx + Docker Setup

Automated setup for running a Flask application with Nginx reverse proxy and SSL in Docker containers.

## ✨ Features

- Flask application with Docker containerization
- Nginx reverse proxy with SSL termination
- Automatic SSL certificate from Let's Encrypt
- Auto-renewal of SSL certificates
- Docker Compose orchestration
- HTTP to HTTPS redirect
- Support for both www and non-www domains
- HSTS enabled
- OCSP stapling

## 🔧 Requirements

- Docker and Docker Compose installed
- Domain name with DNS A records configured
- Port 80 and 443 available
- Internet connection

## 📁 Project Structure

```
.
├── app/                    # Flask application
│   ├── Dockerfile         # Flask container setup
│   ├── main.py           # Flask application code
│   └── requirements.txt   # Python dependencies
├── nginx/
│   └── conf/             # Nginx configuration
│       └── app.conf.template
├── docker-compose.yml     # Service orchestration
└── setup.sh              # Setup script
```

## 🚀 Quick Start

### 1. Clone the Repository
```bash
git clone <repository-url>
cd flask_nginx_docker
```

### 2. Configure DNS
Add these A records to your domain DNS settings:
- yourdomain.com → your-server-ip
- www.yourdomain.com → your-server-ip

### 3. Run Setup
```bash
chmod +x setup.sh
./setup.sh yourdomain.com
```

The setup script will:
- Verify DNS configuration
- Set up directory structure
- Configure Nginx
- Obtain SSL certificate
- Start all services

## 🔄 Post-Setup

### Modifying the Flask Application
1. Edit `app/main.py` to modify your Flask application
2. Rebuild and restart:
```bash
docker-compose up -d --build flask
```

### SSL Certificate Renewal
Certificates auto-renew every 12 hours (if needed).
Manual renewal:
```bash
docker-compose run --rm certbot certbot renew
```

## 🛠️ Customization

### Flask Application
- Modify `app/main.py` for your application logic
- Add dependencies to `app/requirements.txt`
- Update `app/Dockerfile` for additional build steps

### Nginx Configuration
- Edit `nginx/conf/app.conf.template`
- After changes:
```bash
docker-compose restart nginx
```

## ⚠️ Troubleshooting

### DNS Issues
If DNS verification fails:
1. Verify A records are correct at your domain registrar
2. Wait for DNS propagation (can take up to 48 hours)
3. Run setup.sh again

### SSL Certificate Issues
If certificate generation fails:
1. Ensure ports 80/443 are available
2. Check DNS configuration
3. Verify domain ownership
4. Run setup.sh again

## 🗑️ Cleanup
To remove all containers and volumes:
```bash
docker-compose down -v
```

To remove SSL certificates:
```bash
rm -rf ./certbot
```