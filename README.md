# 🛡️ WAF SafeLine + n8n Local Docker Deployment

Complete Docker Compose setup to run **SafeLine WAF** (AI-powered Web Application Firewall) and **n8n** (workflow automation platform) together in a local environment.

## � Table of Contents

- [What is This?](#what-is-this)
- [Quick Start](#quick-start)
- [Services Deployed](#services-deployed)
- [Prerequisites](#prerequisites)
- [Installation](#installation)
- [Access Information](#access-information)
- [Common Commands](#common-commands)
- [Setup in New Environment](#setup-in-new-environment)
- [Troubleshooting](#troubleshooting)
- [Documentation](#documentation)

---

## 🎯 What is This?

This project deploys **9 containerized services** that work together to provide:

### 🔒 **SafeLine WAF** - Enterprise-Grade Security
- **AI-powered threat detection** - Semantic analysis, not just signatures
- **Zero-day protection** - Detects unknown attacks
- **Bot mitigation** - Block malicious bots and scrapers
- **Attack analytics** - Real-time dashboards and logs
- **SSL/TLS termination** - Centralized certificate management

### ⚙️ **n8n** - Workflow Automation
- **Visual workflow builder** - No-code automation
- **200+ integrations** - Connect any API or service
- **Scheduled tasks** - Cron-based automation
- **Webhook triggers** - Event-driven workflows
- **Data transformation** - Process and route data

### 💡 **Combined Benefits**
- Protect n8n with enterprise-grade WAF
- Automate security incident responses
- Centralized security for all your web apps
- Self-hosted, full control over your data

---

## 🚀 Quick Start

### **One-Command Install**

```bash
cd /path/to/waf-safeline
./install.sh
```

**That's it!** The script will:
- ✅ Create required directories
- ✅ Pull all Docker images
- ✅ Start 9 containers
- ✅ Display access credentials

---

## 📦 Services Deployed

| Service | Purpose | Resources |
|---------|---------|-----------|
| **safeline-mgt** | Management console & API | 86 MB RAM |
| **safeline-tengine** | Reverse proxy (routes traffic) | 935 MB RAM |
| **safeline-detector** | AI threat detection engine | 94 MB RAM |
| **safeline-luigi** | Data processing & coordination | 44 MB RAM |
| **safeline-chaos** | Analytics & reporting | 101 MB RAM |
| **safeline-fvm** | File verification & scanning | 124 MB RAM |
| **safeline-pg** | PostgreSQL database | 99 MB RAM |
| **n8n** | Workflow automation engine | 284 MB RAM |
| **n8n-postgres** | n8n database | 58 MB RAM |

**Total**: ~1.8 GB RAM, 9 containers, 2 networks

---

## 📋 Prerequisites

### Required
- **OS**: Linux (Ubuntu 20.04+, Debian 11+, or similar)
- **Docker**: 20.10.14 or later
- **Docker Compose**: 2.0 or later
- **RAM**: Minimum 2 GB available
- **Disk**: At least 10 GB free space
- **CPU**: x86_64/amd64 with ssse3 instruction set

### Verify Your System

```bash
# Check architecture
uname -m

# Check Docker
docker --version

# Check Docker Compose
docker compose version

# Check available memory
free -h

# Check disk space
df -h

# Check CPU instruction set
lscpu | grep ssse3
```

---

## 🔧 Installation

### **Method 1: Automated (Recommended)**

```bash
# Navigate to project directory
cd /path/to/waf-safeline

# Run installer
./install.sh
```

The script will automatically:
1. Create data directories
2. Pull Docker images
3. Start all services
4. Display access credentials

### **Method 2: Manual Installation**

```bash
# 1. Create data directories
mkdir -p safeline-data n8n-data n8n-postgres-data
chmod -R 755 safeline-data n8n-data n8n-postgres-data

# 2. Configure environment (optional)
nano .env
# Change passwords and settings as needed

# 3. Pull images
docker compose pull

# 4. Start services
docker compose up -d

# 5. Wait for initialization (30 seconds)
sleep 30

# 6. Get SafeLine admin password
docker exec safeline-mgt resetadmin
```

### **Environment Variables (.env)**

Key settings you can customize:

- `POSTGRES_PASSWORD` - SafeLine database password
- `N8N_DB_PASSWORD` - n8n database password
- `N8N_BASIC_AUTH_USER` - n8n login username (default: admin)
- `N8N_BASIC_AUTH_PASSWORD` - n8n login password
- `GENERIC_TIMEZONE` - Timezone (e.g., `America/New_York`, `Europe/Berlin`)
- `MGT_PORT` - SafeLine console port (default: 9443)
- `IMAGE_TAG` - SafeLine version (default: latest)

---

## 🌐 Access Information

### **SafeLine WAF Management Console**

```
URL:      https://localhost:9443 (or https://<server-ip>:9443)
Username: admin
Password: Run command below to get/reset password
```

**Get SafeLine Password:**
```bash
docker exec safeline-mgt resetadmin
```

### **n8n Workflow Automation**

```
URL:      http://localhost:5678 (or http://<server-ip>:5678)
Username: Check .env file (N8N_BASIC_AUTH_USER)
Password: Check .env file (N8N_BASIC_AUTH_PASSWORD)
```

**Get n8n Credentials:**
```bash
cat .env | grep N8N_BASIC_AUTH
```

---

## ⚡ Common Commands

### **Check Status**
```bash
# View all running containers
docker compose ps

# Check resource usage
docker stats --no-stream
```

### **View Logs**
```bash
# All services
docker compose logs -f

# Specific service
docker compose logs -f n8n
docker compose logs -f safeline-detector
```

### **Restart Services**
```bash
# Restart all
docker compose restart

# Restart specific service
docker compose restart n8n
docker compose restart safeline-mgt
```

### **Stop/Start**
```bash
# Stop all services
docker compose down

# Start all services
docker compose up -d

# Restart from scratch
docker compose down && docker compose up -d
```

### **Update to Latest Version**
```bash
# Pull latest images
docker compose pull

# Recreate containers with new images
docker compose up -d --force-recreate

# Verify
docker compose ps
```

---

## 🚀 Setup in New Environment

### **Quick Transfer to New Server**

```bash
# On old server: Create backup
tar -czf waf-safeline-backup.tar.gz waf-safeline/

# Transfer to new server
scp waf-safeline-backup.tar.gz user@newserver:/opt/

# On new server: Extract and install
cd /opt
tar -xzf waf-safeline-backup.tar.gz
cd waf-safeline
./install.sh
```

### **Fresh Installation on New Machine**

```bash
# Copy project files to new machine
# Then run:
cd /path/to/waf-safeline
```

See **[SETUP-NEW-ENV.md](SETUP-NEW-ENV.md)** for detailed instructions.

---

## 🔍 Troubleshooting

### **Container Won't Start**

```bash
# Check logs for specific container
docker compose logs safeline-mgt
docker compose logs n8n

# Check all container status
docker compose ps

# Restart specific container
docker compose restart <container-name>
```

### **Port Already in Use**

```bash
# Find process using port
sudo lsof -i :9443
sudo lsof -i :5678

# Kill process or change port in .env
nano .env
# Update MGT_PORT=9444
docker compose up -d
```

### **Out of Disk Space**

```bash
# Check Docker disk usage
docker system df

# Clean up unused resources
docker system prune -a

# Check filesystem
df -h
```

### **Permission Denied on Data Directories**

```bash
# Fix ownership
sudo chown -R $(whoami):$(whoami) safeline-data n8n-data n8n-postgres-data

# Fix permissions
chmod -R 755 safeline-data n8n-data n8n-postgres-data
```

### **SafeLine Containers Keep Restarting**

```bash
# Check if CPU has required instruction set
lscpu | grep ssse3

# Check memory availability
free -h

# Review logs
docker compose logs safeline-detector
```

### **Can't Access Web Interface**

```bash
# Check if container is running
docker compose ps | grep safeline-mgt

# Check if port is listening
sudo netstat -tulpn | grep :9443

# Try from different browser or incognito mode
# Accept self-signed SSL certificate
```

### **Database Connection Errors**

```bash
# Check PostgreSQL containers
docker compose ps | grep postgres

# Restart databases
docker compose restart safeline-pg n8n-postgres

# Check database logs
docker compose logs safeline-pg
docker compose logs n8n-postgres
```

---

## 💾 Backup & Restore

### **Create Backup**

```bash
# Stop services first (recommended)
docker compose down

# Backup everything
tar -czf backup-$(date +%Y%m%d).tar.gz \
  docker-compose.yml \
  .env \
  safeline-data \
  n8n-data \
  n8n-postgres-data

# Restart services
docker compose up -d
```

### **Database Backups**

```bash
# SafeLine database
docker exec safeline-pg pg_dumpall -U postgres > safeline-backup.sql

# n8n database
docker exec n8n-postgres pg_dump -U n8n n8n > n8n-backup.sql
```

### **Restore from Backup**

```bash
# Stop services
docker compose down

# Extract backup
tar -xzf backup-YYYYMMDD.tar.gz

# Start services
docker compose up -d
```

---

## 🎯 Use Cases

### **1. Protect Web Applications**
- Add your websites to SafeLine WAF
- Block SQL injection, XSS, and other attacks
- Monitor traffic and security events
- Enable bot protection

### **2. Automate Security Workflows**
- Use n8n to monitor SafeLine logs
- Send alerts to Slack/Discord/Email when attacks detected
- Automatically create security tickets
- Export attack data to analytics platforms

### **3. Integrate Multiple Services**
- Centralized WAF protection for all apps
- Route traffic through SafeLine proxy
- SSL/TLS termination in one place
- Unified security policies

### **4. Development Environment**
- Test security configurations locally
- Build and test n8n workflows
- Simulate attack scenarios safely
- Train team on WAF features

---

## 📚 Documentation

- **[COMMANDS.md](COMMANDS.md)** - Quick command reference
- **[SETUP-NEW-ENV.md](SETUP-NEW-ENV.md)** - Detailed setup guide for new environments
- **[DEPLOYMENT.md](DEPLOYMENT.md)** - Comprehensive deployment documentation
- **[QUICKSTART.md](QUICKSTART.md)** - Quick reference guide
- **[ACCESS-INFO.md](ACCESS-INFO.md)** - Access credentials and URLs

---

## � External Resources

- **SafeLine Documentation**: https://docs.waf.chaitin.com/en/
- **n8n Documentation**: https://docs.n8n.io/
- **Docker Documentation**: https://docs.docker.com/
- **Docker Compose Documentation**: https://docs.docker.com/compose/

---

## 🏗️ Architecture

```
┌─────────────────────────────────────────────────────────┐
│                    Internet/Users                        │
└────────────────────┬────────────────────────────────────┘
                     │
                     ▼
         ┌───────────────────────────┐
         │   SafeLine Tengine        │ ← Port 80/443
         │   (Reverse Proxy)         │    (Routes Traffic)
         └───────────┬───────────────┘
                     │
         ┌───────────▼───────────────┐
         │   SafeLine Detector       │ ← AI Analysis
         │   (Threat Detection)      │    (Blocks Attacks)
         └───────────┬───────────────┘
                     │
            ┌────────┴────────┐
            │                 │
      BLOCK Attack      ALLOW Clean Traffic
            │                 │
            ▼                 ▼
     Return Error      Forward to Backend
                             │
                    ┌────────┴────────┐
                    │                 │
                    ▼                 ▼
              ┌─────────┐      ┌──────────┐
              │   n8n   │      │  Other   │
              │ :5678   │      │   Apps   │
              └────┬────┘      └──────────┘
                   │
                   ▼
         ┌─────────────────┐
         │  n8n-postgres   │ ← Workflows & Data
         └─────────────────┘

Supporting Services:
├─ safeline-mgt      → Management Console
├─ safeline-luigi    → Data Processing
├─ safeline-chaos    → Analytics
├─ safeline-fvm      → File Scanning
└─ safeline-pg       → SafeLine Database
```

---

## 📊 Resource Usage

| Component | RAM Usage | Purpose |
|-----------|-----------|---------|
| safeline-tengine | 935 MB | Reverse proxy & caching |
| n8n | 284 MB | Workflow engine |
| safeline-fvm | 124 MB | File scanning |
| safeline-chaos | 101 MB | Analytics |
| safeline-pg | 99 MB | SafeLine database |
| safeline-detector | 94 MB | AI threat detection |
| safeline-mgt | 86 MB | Management console |
| n8n-postgres | 58 MB | n8n database |
| safeline-luigi | 44 MB | Data processing |
| **Total** | **~1.8 GB** | All 9 services |

---

## 🔐 Security Best Practices

### **For Production Use**

1. **Change All Default Passwords**
   ```bash
   nano .env
   # Update all passwords with strong values
   ```

2. **Configure Firewall**
   ```bash
   # Allow only necessary ports
   sudo ufw allow 9443/tcp  # SafeLine console
   sudo ufw allow 80/tcp    # HTTP
   sudo ufw allow 443/tcp   # HTTPS
   sudo ufw enable
   ```

3. **Use SSL Certificates**
   - Upload proper SSL certificates in SafeLine console
   - Don't use self-signed certificates in production

4. **Regular Backups**
   ```bash
   # Set up automated backups
   crontab -e
   # Add: 0 2 * * * /path/to/backup-script.sh
   ```

5. **Keep Updated**
   ```bash
   # Monthly updates
   docker compose pull
   docker compose up -d --force-recreate
   ```

6. **Monitor Logs**
   ```bash
   # Set up log monitoring
   docker compose logs -f safeline-detector | grep -i "attack"
   ```

7. **Restrict Access**
   - Only expose necessary ports
   - Use VPN for management interfaces
   - Enable 2FA where available

---

## 🚦 Health Monitoring

### **Quick Health Check**

```bash
# Check all services are running
docker compose ps

# Check resource usage
docker stats --no-stream

# Test endpoints
curl -k https://localhost:9443  # SafeLine
curl http://localhost:5678      # n8n
```

### **Automated Monitoring Script**

Create `health-check.sh`:

```bash
#!/bin/bash
SERVICES=("safeline-mgt" "safeline-tengine" "safeline-detector" "n8n")

for service in "${SERVICES[@]}"; do
  if docker compose ps | grep $service | grep -q "Up"; then
    echo "✅ $service is running"
  else
    echo "❌ $service is DOWN"
  fi
done
```

---

## 📈 Performance Tuning

### **Increase Memory Limits**

Edit `docker-compose.yml` to add memory limits:

```yaml
services:
  safeline-detector:
    mem_limit: 512m
    mem_reservation: 256m
```

### **Optimize PostgreSQL**

For heavy workloads, tune PostgreSQL in `.env`:

```bash
POSTGRES_SHARED_BUFFERS=256MB
POSTGRES_MAX_CONNECTIONS=100
```

### **Enable Docker Logging**

Configure log rotation in `/etc/docker/daemon.json`:

```json
{
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "10m",
    "max-file": "3"
  }
}
```

---

## 🎓 Next Steps After Installation

1. **✅ Verify Installation**
   ```bash
   docker compose ps
   docker stats --no-stream
   ```

2. **🔐 Access SafeLine Console**
   - Open `https://localhost:9443`
   - Get password: `docker exec safeline-mgt resetadmin`
   - Login and explore the dashboard

3. **⚙️ Configure Your First Protected Site**
   - Click "Add Application" in SafeLine
   - Set upstream to your backend service
   - Configure security policies

4. **🔧 Set Up n8n Workflow**
   - Open `http://localhost:5678`
   - Create your first automation workflow
   - Test webhook triggers

5. **🛡️ Protect n8n with SafeLine**
   - Add n8n as protected application
   - Configure reverse proxy settings
   - Test access through WAF

6. **📊 Monitor Activity**
   - Check SafeLine dashboard for threats
   - Review attack logs and patterns
   - Tune security rules as needed

7. **💾 Set Up Backups**
   - Configure automated backups
   - Test restore procedure
   - Document backup location

---

## ❓ FAQ

### **Q: Can I run this in production?**
A: Yes, but ensure you:
- Change all default passwords
- Use proper SSL certificates
- Configure firewall rules
- Set up monitoring and backups
- Keep services updated

### **Q: How much resources do I need?**
A: Minimum:
- 2 CPU cores
- 2 GB RAM
- 10 GB disk space

Recommended for production:
- 4 CPU cores
- 4 GB RAM
- 50 GB SSD

### **Q: Can I protect multiple websites?**
A: Yes! Add multiple applications in SafeLine console. Each can have different security policies.

### **Q: How do I update to the latest version?**
A: 
```bash
docker compose pull
docker compose up -d --force-recreate
```

### **Q: Where are my workflows stored?**
A: n8n workflows are in `n8n-postgres-data/` directory. Back this up regularly.

### **Q: Can I use this with Kubernetes?**
A: This setup is Docker Compose based. For Kubernetes, you'll need to convert to K8s manifests or use Helm charts.

### **Q: Is SafeLine free?**
A: Yes, SafeLine Community Edition is free and open-source.

### **Q: How do I migrate to a new server?**
A: See [SETUP-NEW-ENV.md](SETUP-NEW-ENV.md) for complete migration guide.

---

## 🤝 Contributing

Contributions welcome! Please:
1. Fork the repository
2. Create a feature branch
3. Test your changes
4. Submit a pull request

---

## 📄 License

This project configuration is provided as-is. Please refer to individual component licenses:
- SafeLine WAF: Check https://docs.waf.chaitin.com/
- n8n: Fair-code (Sustainable Use License)

---

## 🆘 Support

**Need help?**
- Check [COMMANDS.md](COMMANDS.md) for quick reference
- See [SETUP-NEW-ENV.md](SETUP-NEW-ENV.md) for detailed setup
- Review [Troubleshooting](#troubleshooting) section above
- Check component documentation:
  - SafeLine: https://docs.waf.chaitin.com/en/
  - n8n: https://docs.n8n.io/

**Found a bug?**
- Check existing issues
- Create detailed bug report
- Include logs: `docker compose logs`

---

## 🎉 Acknowledgments

- **Chaitin Tech** for SafeLine WAF
- **n8n.io** for the automation platform
- **Docker** for containerization

---

**Last Updated**: November 14, 2025
**Version**: 1.0

---

Made with ❤️ for the DevSecOps community
