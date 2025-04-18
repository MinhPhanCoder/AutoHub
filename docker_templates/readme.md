# 🐳 Docker Templates

Collection of production-ready Dockerfile templates for various programming languages and frameworks.

## 📁 Available Templates

### Python (`/python`)
- Python 3.11 with slim base image
- Includes gcc for building dependencies
- Optimized dependency installation
- Example structure for Flask/FastAPI apps

### Node.js (`/nodejs`)
- Node.js 18 LTS with slim base image
- NPM dependency management
- Configured for Express/Next.js apps
- Port 3000 exposed by default

### Java (`/java`)
- Multi-stage build with JDK 17 and JRE
- Maven-based build process
- Spring Boot optimized
- Minimal runtime image

### PHP (`/php`)
- PHP 8.2 FPM
- Composer dependency management
- Common extensions pre-installed
- Optimized for Laravel/Symfony

### Go (`/golang`)
- Multi-stage build with Go 1.20
- Alpine-based minimal image
- CGO support included
- Optimized for production

## 🚀 Usage

### 1. Choose Your Template
Copy the relevant template directory for your project:
```bash
cp -r docker_templates/[language] your-project/
```

### 2. Project Structure
Create this structure in your project:
```
your-project/
├── Dockerfile          # From template
├── app/               # Your application code
└── dependency-files   # package.json, requirements.txt, etc.
```

### 3. Configuration Files

#### Python
- Create `requirements.txt`:
```txt
flask==2.3.3
gunicorn==21.2.0
```

#### Node.js
- Create `package.json`:
```json
{
  "name": "app",
  "version": "1.0.0",
  "scripts": {
    "start": "node index.js"
  }
}
```

#### Java
- Create `pom.xml` for Maven configuration
- Use Spring Boot starter if needed

#### PHP
- Create `composer.json` for dependencies
- Configure php.ini if needed

#### Go
- Create `go.mod` and `go.sum`
- Place main.go in app directory

### 4. Build & Run

Build the image:
```bash
docker build -t myapp .
```

Run the container:
```bash
docker run -p 8080:8080 myapp
```

## 🔧 Customization

### Adding Dependencies
- Python: Add to requirements.txt
- Node.js: Add to package.json
- Java: Add to pom.xml
- PHP: Add to composer.json
- Go: Add to go.mod

### Changing Base Image
Modify the FROM line in Dockerfile:
```dockerfile
FROM python:3.11-slim  # Example
```

### Adding Build Steps
Add RUN commands in Dockerfile:
```dockerfile
RUN apt-get update && apt-get install -y package-name
```

## 🔒 Security Best Practices

1. Use specific version tags
2. Keep base images updated
3. Use multi-stage builds where possible
4. Run as non-root user
5. Scan images for vulnerabilities
6. Remove build tools in final stage

## 📝 Development Tips

### Hot Reload
For development, mount your code as a volume:
```bash
docker run -v $(pwd)/app:/app myapp
```

### Debugging
Add debugging tools in development:
```dockerfile
RUN apt-get install -y curl vim  # Development only
```

### Environment Variables
Use ARG for build-time variables:
```dockerfile
ARG NODE_ENV=production
ENV NODE_ENV=$NODE_ENV
```

## ⚠️ Common Issues

### Build Failures
1. Check dependency files exist
2. Verify file permissions
3. Ensure internet connectivity
4. Check disk space

### Runtime Issues
1. Verify port mappings
2. Check environment variables
3. Validate volume mounts
4. Review container logs