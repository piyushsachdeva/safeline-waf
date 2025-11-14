#!/bin/bash

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${BLUE}════════════════════════════════════════════════════════${NC}"
echo -e "${BLUE}   WAF SafeLine + n8n Local Deployment Script${NC}"
echo -e "${BLUE}════════════════════════════════════════════════════════${NC}"
echo ""

# Check if Docker is installed
if ! command -v docker &> /dev/null; then
    echo -e "${RED}❌ Docker is not installed. Please install Docker first.${NC}"
    exit 1
fi

# Check if Docker Compose is available
if ! docker compose version &> /dev/null; then
    echo -e "${RED}❌ Docker Compose is not available. Please install Docker Compose.${NC}"
    exit 1
fi

echo -e "${GREEN}✓ Docker and Docker Compose are installed${NC}"

# Check if .env file exists
if [ ! -f .env ]; then
    echo -e "${YELLOW}⚠ .env file not found. Creating from template...${NC}"
    if [ -f .env.example ]; then
        cp .env.example .env
        echo -e "${YELLOW}⚠ Please edit .env file and configure your passwords before running again.${NC}"
        exit 1
    else
        echo -e "${RED}❌ Neither .env nor .env.example found. Cannot continue.${NC}"
        exit 1
    fi
fi

echo -e "${GREEN}✓ Configuration file found${NC}"

# Create required directories
echo -e "${BLUE}📁 Creating required directories...${NC}"
mkdir -p safeline-data/{resources,logs}
mkdir -p n8n-data n8n-files n8n-postgres-data

# Set permissions
chmod -R 755 safeline-data n8n-data n8n-files n8n-postgres-data

echo -e "${GREEN}✓ Directories created${NC}"

# Pull latest images
echo -e "${BLUE}📦 Pulling Docker images (this may take a few minutes)...${NC}"
docker compose pull

# Start services
echo -e "${BLUE}🚀 Starting all services...${NC}"
docker compose up -d

# Wait for services to be ready
echo -e "${BLUE}⏳ Waiting for services to initialize (this may take 2-3 minutes)...${NC}"
sleep 10

# Check if containers are running
echo -e "${BLUE}🔍 Checking container status...${NC}"
echo ""
docker compose ps
echo ""

# Get container status
SAFELINE_STATUS=$(docker compose ps safeline-mgt --format json 2>/dev/null | grep -q "Up" && echo "running" || echo "not running")
N8N_STATUS=$(docker compose ps n8n --format json 2>/dev/null | grep -q "Up" && echo "running" || echo "not running")

if [ "$SAFELINE_STATUS" = "running" ] && [ "$N8N_STATUS" = "running" ]; then
    echo -e "${GREEN}════════════════════════════════════════════════════════${NC}"
    echo -e "${GREEN}✓ All services started successfully!${NC}"
    echo -e "${GREEN}════════════════════════════════════════════════════════${NC}"
    echo ""
    echo -e "${YELLOW}📝 Next Steps:${NC}"
    echo ""
    echo -e "${BLUE}1. Access SafeLine WAF:${NC}"
    echo -e "   URL: ${GREEN}https://localhost:9443${NC}"
    echo -e "   Get admin credentials by running:"
    echo -e "   ${YELLOW}docker exec safeline-mgt resetadmin${NC}"
    echo ""
    echo -e "${BLUE}2. Access n8n Workflow Automation:${NC}"
    echo -e "   URL: ${GREEN}http://localhost:5678${NC}"
    echo -e "   Username: Check ${YELLOW}N8N_BASIC_AUTH_USER${NC} in .env file"
    echo -e "   Password: Check ${YELLOW}N8N_BASIC_AUTH_PASSWORD${NC} in .env file"
    echo ""
    echo -e "${YELLOW}⚠  Important Notes:${NC}"
    echo -e "   • Wait 2-3 minutes for services to fully initialize"
    echo -e "   • SafeLine uses a self-signed certificate (accept in browser)"
    echo -e "   • View logs: ${YELLOW}docker compose logs -f${NC}"
    echo -e "   • Stop services: ${YELLOW}docker compose stop${NC}"
    echo -e "   • Remove everything: ${YELLOW}docker compose down -v${NC}"
    echo ""
else
    echo -e "${RED}════════════════════════════════════════════════════════${NC}"
    echo -e "${RED}❌ Some services failed to start${NC}"
    echo -e "${RED}════════════════════════════════════════════════════════${NC}"
    echo ""
    echo -e "${YELLOW}Check logs for errors:${NC}"
    echo -e "   ${YELLOW}docker compose logs${NC}"
    echo ""
fi
