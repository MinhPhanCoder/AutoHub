#!/bin/bash

# Colors
GREEN='\033[0;32m'
NC='\033[0m'
LINE="==================================="

echo -e "${GREEN}$LINE"
echo "🚀 Starting Flask API with Nginx SSL..."
echo -e "$LINE${NC}"

# Start docker compose
docker-compose down
docker-compose up --build -d

echo -e "${GREEN}$LINE"
echo "✅ System is running!"
echo "🌐 Access the API at: https://localhost"
echo "📝 API Endpoints:"
echo "  - GET /        - Welcome message"
echo "  - GET /health  - Health check"
echo "  - GET /info    - Application info"
echo -e "$LINE${NC}"