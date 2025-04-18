#!/bin/bash

# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'
LINE="==================================="

# Function to test HTTP endpoint
test_endpoint() {
    local url=$1
    local max_attempts=30
    local attempt=1
    local wait_time=2

    echo -e "${YELLOW}Testing endpoint: $url${NC}"
    
    while [ $attempt -le $max_attempts ]; do
        response=$(curl -s -w "\n%{http_code}" "$url")
        status=$(echo "$response" | tail -n1)
        body=$(echo "$response" | head -n1)
        
        if [ "$status" = "200" ]; then
            echo -e "${GREEN}✅ Endpoint test successful!"
            echo -e "Response: $body${NC}"
            return 0
        fi
        
        echo -e "${YELLOW}Attempt $attempt/$max_attempts - Service not ready (Status: $status)${NC}"
        attempt=$((attempt + 1))
        sleep $wait_time
    done
    
    echo -e "${RED}❌ Endpoint test failed after $max_attempts attempts${NC}"
    return 1
}

# Check if project directory exists
if [ ! -f "docker-compose.yml" ]; then
    echo -e "${RED}❌ No docker-compose.yml found in current directory${NC}"
    exit 1
fi

# Start containers
echo -e "${YELLOW}Starting containers...${NC}"
docker-compose up -d --build

# Test endpoints
echo -e "${YELLOW}Waiting for service to be ready...${NC}"
test_endpoint "http://localhost:8080"
health_status=$?
test_endpoint "http://localhost:8080/health"
api_status=$?

# Show container logs if tests failed
if [ $health_status -ne 0 ] || [ $api_status -ne 0 ]; then
    echo -e "${RED}❌ Tests failed! Container logs:${NC}"
    docker-compose logs
    docker-compose down
    exit 1
fi

echo -e "${GREEN}$LINE"
echo "✅ All tests passed!"
echo "💡 Container is running and API is responding"
echo -e "$LINE${NC}"

# Clean up
read -p "Would you like to stop the containers? (y/n) " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    docker-compose down
fi