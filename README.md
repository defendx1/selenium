# Selenium Grid Docker Installation Script

![Selenium Logo](data:image/png;base64,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)

A comprehensive automated installation script for deploying Selenium Grid web automation testing platform with Docker, Nginx reverse proxy, and SSL certificates. Designed to work alongside existing monitoring services without conflicts.

## 🚀 Features

- **Complete Selenium Grid**: Hub with configurable Chrome, Firefox, and Edge nodes
- **Automated Installation**: Minimal user input for complete grid deployment
- **Docker-based**: Uses official Selenium 4.15.0 Docker images
- **SSL/HTTPS Support**: Automatic SSL certificate generation with Let's Encrypt
- **Nginx Reverse Proxy**: Professional web server configuration with WebDriver optimization
- **VNC Access**: Visual debugging with remote desktop access to browser sessions
- **Conflict-Free**: Automatically detects and avoids port conflicts with existing services
- **Dynamic Scaling**: Scale browser nodes up or down based on testing needs
- **File Management**: Integrated download/upload directories for test automation
- **Management Scripts**: Built-in scripts for easy maintenance and monitoring
- **Test Integration**: Sample test scripts and connectivity validation

## 📋 Prerequisites

### System Requirements
- **OS**: Ubuntu 18.04+ / Debian 10+ / CentOS 7+
- **RAM**: Minimum 4GB (recommended 8GB+ for multiple browser nodes)
- **Disk Space**: Minimum 10GB free space
- **Network**: Public IP address with domain pointing to it
- **Privileges**: Root access or sudo privileges

### Required Software (Must be Pre-installed)
- **Docker**: Container runtime (script checks for existing installation)
- **Docker Compose**: Container orchestration tool
- **Nginx**: Web server for reverse proxy
- **Certbot**: Will be installed automatically if missing

### Required Ports
- **80**: HTTP (for SSL certificate validation)
- **443**: HTTPS (Nginx reverse proxy)
- **4444+**: Selenium Hub (automatically assigned to avoid conflicts)
- **5900+**: VNC ports for visual debugging (automatically assigned)

## 🛠 Installation

### Quick Start

1. **Clone the repository**:
   ```bash
   git clone https://github.com/defendx1/Selenium.git
   cd Selenium
   chmod +x install-selenium.sh
   ```

   **Or download directly**:
   ```bash
   wget https://raw.githubusercontent.com/defendx1/Selenium/main/install-selenium.sh
   chmod +x install-selenium.sh
   ```

2. **Run the installation**:
   ```bash
   sudo ./install-selenium.sh
   ```

3. **Follow the prompts**:
   - Enter your domain name (e.g., `selenium.yourdomain.com`)
   - Provide email for SSL certificate
   - Configure number of browser nodes:
     - Chrome nodes (default: 2)
     - Firefox nodes (default: 2)
     - Edge nodes (default: 1)

### Manual Installation Steps

The script automatically handles:
- ✅ Prerequisites validation (Docker, Docker Compose, Nginx)
- ✅ Port conflict detection and resolution
- ✅ Directory structure creation
- ✅ Selenium Grid configuration
- ✅ Docker Compose setup with multiple browser nodes
- ✅ SSL certificate generation
- ✅ Nginx reverse proxy configuration
- ✅ Management and test script creation

## 🔧 Configuration

### Default Access
- **Grid Console**: `https://your-domain.com`
- **WebDriver Hub**: `https://your-domain.com/wd/hub`
- **Grid API**: `https://your-domain.com/grid/api/hub`
- **VNC Password**: `selenium123`

### Docker Services
The installation creates the following containers:
- `selenium-hub`: Central Selenium Grid hub
- `chrome-node-{1-N}`: Chrome browser nodes with VNC
- `firefox-node-{1-N}`: Firefox browser nodes with VNC
- `edge-node-{1-N}`: Edge browser nodes with VNC

### File Structure
```
/opt/selenium-grid/
├── docker-compose.yml          # Main Docker Compose configuration
├── .env                        # Environment variables
├── manage-selenium.sh          # Management script
├── test-selenium.py           # Python test script
├── config/                    # Selenium configuration files
│   ├── hub-config.json        # Hub configuration
│   └── node-config.json       # Node template configuration
├── downloads/                 # Test file downloads directory
├── uploads/                   # Test file uploads directory
└── videos/                    # Test recording storage (future use)
```

## 🎮 Management Commands

Use the built-in management script for easy operations:

```bash
cd /opt/selenium-grid

# Start Selenium Grid
./manage-selenium.sh start

# Stop Selenium Grid
./manage-selenium.sh stop

# Restart Selenium Grid
./manage-selenium.sh restart

# View logs (all services)
./manage-selenium.sh logs

# View specific service logs
./manage-selenium.sh logs hub           # Hub logs
./manage-selenium.sh logs chrome        # Chrome node logs
./manage-selenium.sh logs firefox       # Firefox node logs
./manage-selenium.sh logs edge          # Edge node logs

# Check status and display connection info
./manage-selenium.sh status

# Create backup
./manage-selenium.sh backup

# Update Selenium images
./manage-selenium.sh update

# Scale browser nodes dynamically
./manage-selenium.sh scale chrome 5     # Scale Chrome nodes to 5
./manage-selenium.sh scale firefox 3    # Scale Firefox nodes to 3
./manage-selenium.sh scale edge 2       # Scale Edge nodes to 2

# Test grid connectivity
./manage-selenium.sh test

# Clean up old files and Docker resources
./manage-selenium.sh cleanup
```

## 🔐 Security Features

### SSL/TLS Configuration
- **TLS 1.2/1.3** support only
- **HSTS** (HTTP Strict Transport Security) headers
- **Security headers**: X-Content-Type-Options, X-Frame-Options, X-XSS-Protection
- **Automatic HTTP to HTTPS** redirection

### Network Security
- All services accessible only through Nginx reverse proxy
- Selenium nodes isolated in dedicated Docker network
- VNC access limited to localhost (use SSH tunneling for remote access)
- File upload/download directories with controlled access

### WebDriver Optimization
- Extended timeouts for long-running test sessions
- WebSocket support for real-time Grid features
- Optimized proxy settings for WebDriver communication
- Large file upload support (up to 100MB)

## 🕷️ Selenium Grid Usage

### WebDriver Connection Examples

#### Python (Selenium)
```python
from selenium import webdriver
from selenium.webdriver.common.desired_capabilities import DesiredCapabilities

# Chrome browser
driver = webdriver.Remote(
    command_executor='https://selenium.yourdomain.com/wd/hub',
    desired_capabilities=DesiredCapabilities.CHROME
)

# Firefox browser
driver = webdriver.Remote(
    command_executor='https://selenium.yourdomain.com/wd/hub',
    desired_capabilities=DesiredCapabilities.FIREFOX
)

# Edge browser
driver = webdriver.Remote(
    command_executor='https://selenium.yourdomain.com/wd/hub',
    desired_capabilities=DesiredCapabilities.EDGE
)

driver.get('https://example.com')
driver.quit()
```

#### Java (Selenium)
```java
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.remote.DesiredCapabilities;
import org.openqa.selenium.remote.RemoteWebDriver;
import java.net.URL;

DesiredCapabilities caps = DesiredCapabilities.chrome();
WebDriver driver = new RemoteWebDriver(
    new URL("https://selenium.yourdomain.com/wd/hub"), 
    caps
);

driver.get("https://example.com");
driver.quit();
```

#### Node.js (WebDriverIO)
```javascript
const { remote } = require('webdriverio');

const browser = await remote({
    hostname: 'selenium.yourdomain.com',
    port: 443,
    protocol: 'https',
    path: '/wd/hub',
    capabilities: {
        browserName: 'chrome'
    }
});

await browser.url('https://example.com');
await browser.deleteSession();
```

### Advanced WebDriver Options

```python
from selenium.webdriver.chrome.options import Options

chrome_options = Options()
chrome_options.add_argument('--no-sandbox')
chrome_options.add_argument('--disable-dev-shm-usage')
chrome_options.add_argument('--window-size=1920,1080')

capabilities = DesiredCapabilities.CHROME
capabilities['chromeOptions'] = chrome_options

driver = webdriver.Remote(
    command_executor='https://selenium.yourdomain.com/wd/hub',
    desired_capabilities=capabilities
)
```

## 🖥️ VNC Visual Debugging

### Accessing Browser Sessions

Each browser node provides VNC access for visual debugging:

```bash
# Check VNC port assignments
./manage-selenium.sh status

# Connect using VNC viewer
# Password: selenium123

# Chrome Node 1: localhost:5900
# Chrome Node 2: localhost:5901
# Firefox Node 1: localhost:5902
# Firefox Node 2: localhost:5903
# Edge Node 1: localhost:5904
```

### Remote VNC Access

For remote VNC access, use SSH tunneling:

```bash
# Create SSH tunnel (run on local machine)
ssh -L 5900:localhost:5900 user@your-server.com

# Then connect VNC viewer to localhost:5900
```

### VNC Viewers
- **Windows**: TightVNC, UltraVNC, RealVNC
- **macOS**: Built-in Screen Sharing, RealVNC
- **Linux**: Remmina, TigerVNC, Vinagre

## 🧪 Testing and Validation

### Built-in Test Script

```bash
# Test all browsers
python3 /opt/selenium-grid/test-selenium.py

# Test specific browser
python3 /opt/selenium-grid/test-selenium.py chrome
python3 /opt/selenium-grid/test-selenium.py firefox
python3 /opt/selenium-grid/test-selenium.py edge

# Quick connectivity test
./manage-selenium.sh test
```

### Grid Status Monitoring

```bash
# Check grid status via API
curl -s https://selenium.yourdomain.com/wd/hub/status | jq

# Check available nodes
curl -s https://selenium.yourdomain.com/grid/api/hub | jq '.slotCounts'

# View active sessions
curl -s https://selenium.yourdomain.com/wd/hub/sessions | jq
```

## 📊 Scaling and Performance

### Dynamic Node Scaling

```bash
# Scale up Chrome nodes for heavy testing
./manage-selenium.sh scale chrome 10

# Scale down Firefox nodes
./manage-selenium.sh scale firefox 1

# Scale Edge nodes
./manage-selenium.sh scale edge 3
```

### Performance Optimization

#### Resource Allocation
Edit `/opt/selenium-grid/docker-compose.yml`:

```yaml
services:
  chrome-node-1:
    deploy:
      resources:
        limits:
          memory: 2G
          cpus: '1.0'
        reservations:
          memory: 1G
          cpus: '0.5'
```

#### Hub Configuration
Edit `/opt/selenium-grid/config/hub-config.json`:

```json
{
  "port": 4444,
  "newSessionWaitTimeout": 30000,
  "browserTimeout": 300,
  "timeout": 60
}
```

### Load Testing Considerations

- **Concurrent Sessions**: Each node supports 1 concurrent session by default
- **Memory Usage**: Chrome ~1-2GB, Firefox ~1GB, Edge ~1-2GB per session
- **CPU Usage**: ~0.5-1 CPU core per active session
- **Network**: Consider bandwidth for VNC and WebDriver traffic

## 🔄 Backup and Restore

### Automated Backup
```bash
./manage-selenium.sh backup
```
Creates timestamped backup including:
- Docker Compose configuration
- Selenium configuration files
- Environment variables (excluding download/upload files)

### Manual Backup
```bash
# Stop Selenium Grid
./manage-selenium.sh stop

# Create full backup
tar -czf selenium-backup-$(date +%Y%m%d).tar.gz /opt/selenium-grid/

# Start Selenium Grid
./manage-selenium.sh start
```

### Restore Process
```bash
# Stop Selenium Grid
./manage-selenium.sh stop

# Restore configuration
tar -xzf selenium-backup.tar.gz -C /opt/selenium-grid/

# Update Docker images
docker-compose pull

# Start Selenium Grid
./manage-selenium.sh start
```

## 🚨 Troubleshooting

### Common Issues

**1. Grid won't start**
```bash
# Check logs
./manage-selenium.sh logs

# Check Docker daemon
systemctl status docker

# Verify port availability
netstat -tlnp | grep :4444
```

**2. Nodes not connecting to hub**
```bash
# Check node logs
./manage-selenium.sh logs chrome

# Verify network connectivity
docker network ls
docker network inspect selenium-network
```

**3. WebDriver connection failures**
```bash
# Test hub connectivity
curl -I https://selenium.yourdomain.com/wd/hub/status

# Check SSL certificate
curl -vI https://selenium.yourdomain.com/
```

**4. VNC connection issues**
```bash
# Check VNC ports
./manage-selenium.sh status

# Test VNC connectivity
nc -zv localhost 5900
```

**5. Browser sessions hanging**
```bash
# Check browser processes
docker exec chrome-node-1 ps aux

# Restart specific node
docker-compose restart chrome-node-1

# Clear browser data
./manage-selenium.sh cleanup
```

### Log Locations
- **Selenium Hub**: `docker logs selenium-hub`
- **Browser Nodes**: `docker logs chrome-node-1`
- **Nginx**: `/var/log/nginx/selenium.yourdomain.com_*.log`
- **System**: `/var/log/syslog`

### Performance Monitoring

```bash
# Monitor resource usage
docker stats

# Check grid load
curl -s https://selenium.yourdomain.com/grid/api/hub | jq '.slotCounts'

# Monitor file system usage
df -h /opt/selenium-grid/
```

## 🔄 Updates and Maintenance

### Update Selenium Grid
```bash
cd /opt/selenium-grid
./manage-selenium.sh update
```

### Manual Image Updates
```bash
# Pull latest images
docker-compose pull

# Recreate containers with new images
docker-compose up -d --force-recreate
```

### Maintenance Schedule
```bash
# Daily cleanup (add to cron)
0 2 * * * /opt/selenium-grid/manage-selenium.sh cleanup

# Weekly backup (add to cron)
0 3 * * 0 /opt/selenium-grid/manage-selenium.sh backup
```

## 📊 Advanced Configuration

### Custom Browser Options

#### Chrome with Custom Options
```yaml
environment:
  - SE_OPTS="--chrome-options --disable-web-security --ignore-certificate-errors"
```

#### Firefox with Custom Profile
```yaml
volumes:
  - ./firefox-profile:/tmp/firefox-profile:ro
environment:
  - SE_OPTS="--firefox-profile /tmp/firefox-profile"
```

### Grid Hub Customization

```yaml
environment:
  - GRID_MAX_SESSION=20
  - GRID_BROWSER_TIMEOUT=300
  - GRID_TIMEOUT=60
  - GRID_NEW_SESSION_WAIT_TIMEOUT=30
```

### SSL Configuration for Internal CA

```yaml
environment:
  - SE_OPTS="--ssl-ca-cert /path/to/ca.crt"
volumes:
  - ./ssl/ca.crt:/path/to/ca.crt:ro
```

## 🔗 Integration Examples

### CI/CD Pipeline Integration

#### GitHub Actions
```yaml
name: Selenium Tests
on: [push, pull_request]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      - name: Run Selenium Tests
        run: |
          python -m pytest tests/ \
            --selenium-hub=https://selenium.yourdomain.com/wd/hub
```

#### Jenkins Pipeline
```groovy
pipeline {
    agent any
    stages {
        stage('Selenium Tests') {
            steps {
                sh '''
                    python -m pytest tests/ \
                        --selenium-hub=https://selenium.yourdomain.com/wd/hub \
                        --browser=chrome
                '''
            }
        }
    }
}
```

### Test Framework Integration

#### pytest-selenium
```python
# conftest.py
import pytest
from selenium import webdriver
from selenium.webdriver.common.desired_capabilities import DesiredCapabilities

@pytest.fixture
def driver():
    driver = webdriver.Remote(
        command_executor='https://selenium.yourdomain.com/wd/hub',
        desired_capabilities=DesiredCapabilities.CHROME
    )
    yield driver
    driver.quit()
```

#### TestNG (Java)
```java
@BeforeMethod
public void setUp() {
    DesiredCapabilities caps = DesiredCapabilities.chrome();
    try {
        driver = new RemoteWebDriver(
            new URL("https://selenium.yourdomain.com/wd/hub"), 
            caps
        );
    } catch (Exception e) {
        e.printStackTrace();
    }
}
```

## 🆘 Support and Resources

### Project Resources
- **GitHub Repository**: [https://github.com/defendx1/Selenium](https://github.com/defendx1/Selenium)
- **Issues & Support**: [Report Issues](https://github.com/defendx1/Selenium/issues)
- **Latest Releases**: [View Releases](https://github.com/defendx1/Selenium/releases)

### Official Documentation
- [Selenium Grid Documentation](https://selenium-python.readthedocs.io/en/stable/index.html)
- [Selenium Docker Images](https://github.com/SeleniumHQ/docker-selenium)
- [WebDriver Specification](https://w3c.github.io/webdriver/)
- [Docker Documentation](https://docs.docker.com/)

### Community Support
- [Selenium Community](https://www.selenium.dev/support/)
- [Selenium Slack](https://seleniumhq.slack.com/)
- [Stack Overflow](https://stackoverflow.com/questions/tagged/selenium)
- [DefendX1 Telegram](https://t.me/defendx1)

## 📄 License

This script is provided under the MIT License. See LICENSE file for details.

---

## 👨‍💻 Author & Contact

**Script Developer**: DefendX1 Team  
**Website**: [https://defendx1.com/](https://defendx1.com/)  
**Telegram**: [t.me/defendx1](https://t.me/defendx1)

### About DefendX1
DefendX1 specializes in cybersecurity solutions, infrastructure automation, and testing platforms. Visit [defendx1.com](https://defendx1.com/) for more security tools and automation resources.

---

## 🔗 Resources & Links

### Project Resources
- **GitHub Repository**: [https://github.com/defendx1/Selenium](https://github.com/defendx1/Selenium)
- **Issues & Support**: [Report Issues](https://github.com/defendx1/Selenium/issues)
- **Latest Releases**: [View Releases](https://github.com/defendx1/Selenium/releases)

### Download & Installation
**GitHub Repository**: [https://github.com/defendx1/Selenium](https://github.com/defendx1/Selenium)

Clone or download the latest version:
```bash
git clone https://github.com/defendx1/Selenium.git
```

## 🤝 Contributing

Contributions are welcome! Please:
1. Fork the repository: [https://github.com/defendx1/Selenium](https://github.com/defendx1/Selenium)
2. Create a feature branch
3. Submit a pull request

## ⭐ Star This Project

If this script helped you, please consider starring the repository at [https://github.com/defendx1/Selenium](https://github.com/defendx1/Selenium)!

---

**Last Updated**: June 2025  
**Version**: 1.0.0
