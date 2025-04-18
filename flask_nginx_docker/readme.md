# 🐳 Flask API with Nginx SSL

Simple Flask API with Nginx reverse proxy and SSL in Docker.

## ✨ Features

- Flask API with basic endpoints
- Nginx reverse proxy with SSL
- Automatic SSL certificate generation in Docker
- Docker multi-stage build
- Error handling and logging
- HTTP to HTTPS redirect

## 🚀 Quick Start

### 1. Download
```bash
git clone https://github.com/MinhPhanCoder/AutoScript.git
cd AutoScript/flask_nginx_docker
```

### 2. Setup Domain (Optional)
For development with localhost:
```bash
./start.sh
```

For production with real domain:
```bash
chmod +x setup_domain.sh
./setup_domain.sh your-domain.com
docker-compose up --build -d
```

### 3. Access API
- Development: https://localhost
- Production: https://your-domain.com

### API Endpoints
- `GET /` - Welcome message and status
- `GET /health` - Health check
- `GET /info` - Application info

## 🔧 Development

### Add New API Endpoints

1. Edit `app.py`:
```python
@app.route('/your-endpoint')
def your_endpoint():
    try:
        return jsonify({
            'data': 'your data'
        })
    except Exception as e:
        app.logger.error(f"Error: {str(e)}")
        return jsonify({'error': 'Error message'}), 500
```

### Add Python Packages

1. Add to `requirements.txt`
2. Rebuild:
```bash
docker-compose up --build -d
```

## 🐞 Troubleshooting

### View Logs
```bash
# Flask logs
docker-compose logs flask

# Nginx logs
docker-compose logs nginx
```

### Common Issues

#### SSL Not Working
- Check Nginx logs
- Verify domain configuration
- Ensure ports 80/443 are open

#### API Not Responding
- Check container status: `docker-compose ps`
- View Flask logs: `docker-compose logs flask`
- Rebuild: `docker-compose up --build -d`