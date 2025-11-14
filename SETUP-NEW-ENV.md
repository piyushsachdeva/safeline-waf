# 🚀 Setup in New Environment

## Prerequisites

- **OS**: Linux (Ubuntu 20.04+, Debian 11+, or similar)
- **Docker**: 20.10.14 or later
- **Docker Compose**: 2.0 or later
- **RAM**: At least 2GB available
- **Disk**: At least 10GB free space
- **Architecture**: x86_64/amd64 (ARM not fully tested)

---

## 🎯 Quick Start (One Command)

```bash
# Clone and setup
git clone <your-repo-url> waf-safeline
cd waf-safeline
chmod +x setup.sh start.sh
./setup.sh
```

**That's it!** The script will:
- ✅ Check all prerequisites
- ✅ Create required directories
- ✅ Configure environment variables
- ✅ Pull Docker images
- ✅ Start all services
- ✅ Display access credentials

---

## 📋 Manual Setup (Step by Step)

### Step 1: Copy Project Files

```bash
# Transfer these files to new environment:
# - docker-compose.yml
# - .env
# - setup.sh
# - start.sh
# - README.md

# Example: Using scp
scp -r waf-safeline/ user@newserver:/opt/
```

### Step 2: Install Docker (if needed)

```bash
# Install Docker
curl -sSL https://get.docker.com/ | bash

# Add current user to docker group
sudo usermod -aG docker $USER

# Log out and back in, then verify
docker --version
docker compose version
```

### Step 3: Setup Directories and Permissions

```bash
cd /path/to/waf-safeline

# Create data directories
mkdir -p safeline-data n8n-data n8n-postgres-data

# Set proper permissions
chmod -R 755 safeline-data n8n-data n8n-postgres-data
```

### Step 4: Configure Environment

```bash
# Review and update .env file if needed
nano .env

# Key variables to check:
# - POSTGRES_PASSWORD (SafeLine DB password)
# - N8N_DB_PASSWORD (n8n DB password)
# - N8N_BASIC_AUTH_USER (default: admin)
# - N8N_BASIC_AUTH_PASSWORD (n8n login password)
# - MGT_PORT (default: 9443)
```

### Step 5: Pull Docker Images

```bash
# Pull all required images (saves time during startup)
docker compose pull
```

### Step 6: Start Services

```bash
# Start all containers in detached mode
docker compose up -d

# Wait for services to initialize (30 seconds)
sleep 30

# Check all containers are running
docker compose ps
```

### Step 7: Get SafeLine Admin Credentials

```bash
# Generate/reset admin password
docker exec safeline-mgt resetadmin

# Output will show:
# [SafeLine] Initial username：admin
# [SafeLine] Initial password：<random-password>
```

---

## 🔍 Verification Commands

### Check All Services Status
```bash
docker compose ps
```

**Expected output**: 9 containers with status "Up"

### Check Resource Usage
```bash
docker stats --no-stream
```

### View Logs
```bash
# All services
docker compose logs -f

# Specific service
docker compose logs -f safeline-mgt
docker compose logs -f n8n
```

### Test Connectivity
```bash
# Test SafeLine management console
curl -k https://localhost:9443

# Test n8n (if port exposed)
curl http://localhost:5678
```

---

## 🌐 Access Your Services

### SafeLine WAF Management Console
- **URL**: `https://localhost:9443` or `https://<server-ip>:9443`
- **Username**: `admin`
- **Password**: Run `docker exec safeline-mgt resetadmin` to get/reset

### n8n Workflow Automation
- **URL**: `http://localhost:5678` or `http://<server-ip>:5678`
- **Username**: Check `N8N_BASIC_AUTH_USER` in `.env` (default: `admin`)
- **Password**: Check `N8N_BASIC_AUTH_PASSWORD` in `.env`

---

## 🔧 Common Issues & Solutions

### Issue: Port 9443 already in use
```bash
# Find process using port
sudo lsof -i :9443

# Change MGT_PORT in .env
nano .env
# Update: MGT_PORT=9444

# Restart
docker compose up -d
```

### Issue: Permission denied on data directories
```bash
# Fix permissions
sudo chown -R $(whoami):$(whoami) safeline-data n8n-data n8n-postgres-data
chmod -R 755 safeline-data n8n-data n8n-postgres-data
```

### Issue: Docker Compose command not found
```bash
# Check if using old version
docker-compose --version

# If old version works, update docker-compose.yml:
# Replace: docker compose
# With: docker-compose
```

### Issue: Out of disk space
```bash
# Clean old Docker images/containers
docker system prune -a

# Check disk usage
df -h
docker system df
```

### Issue: SafeLine containers keep restarting
```bash
# Check logs for specific error
docker compose logs safeline-mgt
docker compose logs safeline-detector

# Common fix: Increase memory allocation
# Edit /etc/docker/daemon.json
```

---

## 🔄 Update/Restart Commands

### Restart All Services
```bash
docker compose restart
```

### Restart Specific Service
```bash
docker compose restart n8n
docker compose restart safeline-mgt
```

### Update to Latest Images
```bash
# Pull latest versions
docker compose pull

# Recreate containers with new images
docker compose up -d --force-recreate
```

### Stop All Services
```bash
docker compose down
```

### Stop and Remove Everything (including data)
```bash
# ⚠️ WARNING: This deletes all data!
docker compose down -v
rm -rf safeline-data n8n-data n8n-postgres-data
```

---

## 📦 Backup & Migration

### Backup Data
```bash
# Create backup directory
mkdir -p backups/$(date +%Y%m%d)

# Backup configuration
cp .env docker-compose.yml backups/$(date +%Y%m%d)/

# Backup data directories
tar -czf backups/$(date +%Y%m%d)/data-backup.tar.gz \
  safeline-data n8n-data n8n-postgres-data

# Backup n8n workflows
docker exec n8n-postgres pg_dump -U n8n n8n > backups/$(date +%Y%m%d)/n8n-db.sql
```

### Restore in New Environment
```bash
# 1. Copy backup to new server
scp -r backups/20251114/ user@newserver:/opt/waf-safeline/

# 2. Extract data
cd /opt/waf-safeline
tar -xzf backups/20251114/data-backup.tar.gz

# 3. Copy configuration
cp backups/20251114/.env .
cp backups/20251114/docker-compose.yml .

# 4. Start services
docker compose up -d

# 5. Wait for initialization
sleep 30

# 6. Restore n8n database (if needed)
docker exec -i n8n-postgres psql -U n8n n8n < backups/20251114/n8n-db.sql
```

---

## 🎯 Production Deployment Checklist

- [ ] Use strong passwords in `.env` (not defaults)
- [ ] Configure firewall rules
  ```bash
  sudo ufw allow 9443/tcp   # SafeLine console
  sudo ufw allow 80/tcp     # HTTP traffic
  sudo ufw allow 443/tcp    # HTTPS traffic
  ```
- [ ] Set up SSL certificates for SafeLine
- [ ] Configure domain names (not localhost)
- [ ] Set up backup cron jobs
- [ ] Configure log rotation
- [ ] Enable Docker auto-restart
  ```bash
  # In docker-compose.yml, add to each service:
  restart: unless-stopped
  ```
- [ ] Monitor disk space usage
- [ ] Set up monitoring/alerting (optional)
- [ ] Document custom configurations

---

## 📞 Support & Resources

- **SafeLine Documentation**: https://docs.waf.chaitin.com/en/
- **n8n Documentation**: https://docs.n8n.io/
- **Project README**: See [README.md](README.md)
- **Quick Start**: See [QUICKSTART.md](QUICKSTART.md)
- **Access Info**: See [ACCESS-INFO.md](ACCESS-INFO.md)

---

## 🚀 Next Steps After Setup

1. **Configure SafeLine WAF**
   - Log into `https://localhost:9443`
   - Add your first application
   - Configure security policies

2. **Set Up n8n Workflows**
   - Log into `http://localhost:5678`
   - Create your first workflow
   - Connect your services

3. **Protect n8n with SafeLine**
   - Add n8n as an application in SafeLine
   - Route traffic through WAF
   - Enable security monitoring

4. **Test Everything**
   - Verify all services are accessible
   - Test WAF protection rules
   - Run test workflows in n8n

---

## ⚡ Pro Tips

1. **Use separate servers** for production vs development
2. **Automate backups** with cron jobs
3. **Monitor logs** regularly for security events
4. **Keep images updated** monthly
5. **Document customizations** for your team
6. **Test restores** periodically to ensure backups work
7. **Use environment-specific .env files** (.env.prod, .env.dev)

---

Last Updated: November 14, 2025
