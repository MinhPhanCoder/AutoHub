#!/bin/bash

# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'
LINE="==================================="

# Check arguments
if [ "$#" -lt 2 ]; then
    echo -e "${RED}Usage: $0 <language> <project-name>${NC}"
    echo -e "Available languages: python, nodejs, java, php, golang"
    exit 1
fi

LANGUAGE=$1
PROJECT_NAME=$2

# Validate language choice
case "$LANGUAGE" in
    python|nodejs|java|php|golang)
        echo -e "${GREEN}Creating $LANGUAGE project: $PROJECT_NAME${NC}"
        ;;
    *)
        echo -e "${RED}Unsupported language: $LANGUAGE${NC}"
        echo "Available languages: python, nodejs, java, php, golang"
        exit 1
        ;;
esac

# Create project directory
mkdir -p "$PROJECT_NAME"

# Copy template files
cp -r "$LANGUAGE"/* "$PROJECT_NAME/"

# Language-specific setup
case "$LANGUAGE" in
    python)
        echo -e "${YELLOW}Setting up Python project...${NC}"
        cd "$PROJECT_NAME"
        python3 -m venv venv
        ;;
    nodejs)
        echo -e "${YELLOW}Setting up Node.js project...${NC}"
        cd "$PROJECT_NAME"
        npm install
        ;;
    java)
        echo -e "${YELLOW}Setting up Java project...${NC}"
        cd "$PROJECT_NAME"
        ./mvnw clean package -DskipTests
        ;;
    php)
        echo -e "${YELLOW}Setting up PHP project...${NC}"
        cd "$PROJECT_NAME"
        composer install
        ;;
    golang)
        echo -e "${YELLOW}Setting up Go project...${NC}"
        cd "$PROJECT_NAME"
        go mod tidy
        ;;
esac

# Create docker-compose.yml
cat > docker-compose.yml << EOF
version: '3.8'

services:
  app:
    build: .
    ports:
      - "8080:8080"
    volumes:
      - ./app:/app
EOF

echo -e "${GREEN}$LINE"
echo "✅ Project setup complete!"
echo "📁 Project created in: $PROJECT_NAME/"
echo ""
echo "🚀 To run the project:"
echo "cd $PROJECT_NAME"
echo "docker-compose up --build"
echo -e "$LINE${NC}"