# ⚡ Quick Command Reference

## 🚀 **Setup in New Environment**

### Method 1: Automated (Easiest)
```bash
cd /path/to/waf-safeline
./install.sh
```

### Method 2: Step-by-Step
```bash
# 1. Create directories
mkdir -p safeline-data n8n-data n8n-postgres-data

# 2. Pull images
docker compose pull

# 3. Start services
docker compose up -d

# 4. Get SafeLine password
docker exec safeline-mgt resetadmin
```

---

## 📋 **Daily Operations**

| Task | Command |
|------|---------|
| **Check Status** | `docker compose ps` |
| **View All Logs** | `docker compose logs -f` |
| **View Specific Log** | `docker compose logs -f n8n` |
| **Restart All** | `docker compose restart` |
| **Restart One Service** | `docker compose restart n8n` |
| **Stop All** | `docker compose down` |
| **Start All** | `docker compose up -d` |
| **Update Images** | `docker compose pull && docker compose up -d --force-recreate` |

---

## 🔐 **Get Credentials**

```bash
# SafeLine admin password
docker exec safeline-mgt resetadmin

# n8n credentials (from .env)
cat .env | grep N8N_BASIC_AUTH
```

---

## 🌐 **Access URLs**

- **SafeLine Console**: `https://localhost:9443`
- **n8n Automation**: `http://localhost:5678`

---

## 🔧 **Troubleshooting**

```bash
# Check container health
docker compose ps

# Check resource usage
docker stats --no-stream

# Check specific service logs
docker compose logs --tail=100 safeline-detector

# Check port conflicts
sudo netstat -tulpn | grep :9443
sudo netstat -tulpn | grep :5678

# Restart problematic service
docker compose restart <service-name>

# Full restart (if issues persist)
docker compose down && docker compose up -d
```

---

## 💾 **Backup**

```bash
# Quick backup
tar -czf backup-$(date +%Y%m%d).tar.gz \
  docker-compose.yml .env \
  safeline-data n8n-data n8n-postgres-data

# Database backups
docker exec safeline-pg pg_dumpall -U postgres > safeline-db-backup.sql
docker exec n8n-postgres pg_dump -U n8n n8n > n8n-db-backup.sql
```

---

## 📦 **Transfer to New Server**

```bash
# On old server: Create backup
tar -czf waf-safeline-backup.tar.gz waf-safeline/

# Transfer to new server
scp waf-safeline-backup.tar.gz user@newserver:/opt/

# On new server: Extract and run
cd /opt
tar -xzf waf-safeline-backup.tar.gz
cd waf-safeline
./install.sh
```

---

## 🧹 **Cleanup**

```bash
# Stop services
docker compose down

# Remove volumes (⚠️ deletes all data!)
docker compose down -v

# Clean Docker system
docker system prune -a

# Remove data directories (⚠️ permanent!)
rm -rf safeline-data n8n-data n8n-postgres-data
```

---

## 🔄 **Update to Latest Version**

```bash
# Pull latest images
docker compose pull

# Recreate containers
docker compose up -d --force-recreate

# Verify
docker compose ps
```

---

## 📊 **Health Checks**

```bash
# All containers running?
docker compose ps | grep -c "Up"

# Check SafeLine console
curl -k https://localhost:9443

# Check n8n
curl http://localhost:5678

# Check disk space
df -h | grep -E "/$|/var/lib/docker"

# Check memory
free -h
```

---

## 🎯 **Production Checklist**

```bash
# 1. Configure firewall
sudo ufw allow 9443/tcp
sudo ufw allow 80/tcp
sudo ufw allow 443/tcp

# 2. Set up auto-start
# Add to /etc/systemd/system/waf-safeline.service

# 3. Configure monitoring
docker stats

# 4. Set up log rotation
# Configure in /etc/docker/daemon.json

# 5. Enable backups (cron)
crontab -e
# Add: 0 2 * * * /opt/waf-safeline/backup.sh
```

---

## 🚨 **Emergency Recovery**

```bash
# If services won't start:
docker compose down
docker system prune -a
docker compose pull
docker compose up -d

# If port conflicts:
sudo lsof -i :9443
sudo lsof -i :5678
# Kill conflicting processes or change ports in .env

# If database corruption:
# Restore from backup
docker compose down
rm -rf safeline-data/pgdata n8n-postgres-data
tar -xzf backup-YYYYMMDD.tar.gz
docker compose up -d
```

---

**Need more help?** See [SETUP-NEW-ENV.md](SETUP-NEW-ENV.md) for detailed guide.
