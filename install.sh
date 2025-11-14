#!/bin/bash
# One-liner installer for WAF SafeLine + n8n
# Usage: curl -fsSL https://raw.githubusercontent.com/your-repo/install.sh | bash

set -e

echo "🚀 Installing WAF SafeLine + n8n..."
echo ""

# Check if in correct directory
if [ ! -f "docker-compose.yml" ]; then
    echo "❌ Error: docker-compose.yml not found!"
    echo "Please run this script from the waf-safeline directory"
    exit 1
fi

# Create directories
echo "📁 Creating data directories..."
mkdir -p safeline-data n8n-data n8n-postgres-data
chmod -R 755 safeline-data n8n-data n8n-postgres-data

# Pull images
echo "📥 Pulling Docker images (this may take a few minutes)..."
docker compose pull

# Start services
echo "🚀 Starting all services..."
docker compose up -d

# Wait for initialization
echo "⏳ Waiting for services to initialize..."
sleep 30

# Get credentials
echo ""
echo "✅ Installation complete!"
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "📋 ACCESS INFORMATION"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "🔒 SafeLine WAF Console:"
echo "   URL: https://localhost:9443"
echo "   Credentials:"
docker exec safeline-mgt resetadmin
echo ""
echo "⚙️  n8n Workflow Automation:"
echo "   URL: http://localhost:5678"
echo "   Username: $(grep N8N_BASIC_AUTH_USER .env | cut -d'=' -f2)"
echo "   Password: $(grep N8N_BASIC_AUTH_PASSWORD .env | cut -d'=' -f2)"
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "📊 Check service status: docker compose ps"
echo "📝 View logs: docker compose logs -f"
echo "🔄 Restart: docker compose restart"
echo "🛑 Stop: docker compose down"
echo ""
echo "📚 For more information, see README.md or SETUP-NEW-ENV.md"
echo ""
