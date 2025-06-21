#!/bin/bash

# Selenium Standalone Installation Script
# Install Selenium Grid with Docker and Nginx SSL
# Create by DefendX1 Team
# https://defendx1.com/

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m'

print_color() {
    local color=$1
    local message=$2
    echo -e "${color}${message}${NC}"
}

print_banner() {
    clear
    print_color $CYAN "======================================"
    print_color $CYAN "     🕷️ Selenium Installation 🕷️"
    print_color $CYAN "======================================"
    print_color $YELLOW "    Web Automation Testing Platform"
    print_color $CYAN "======================================"
    echo
}

check_prerequisites() {
    print_color $BLUE "🔍 Checking prerequisites..."
    
    if [ "$EUID" -ne 0 ]; then
        print_color $RED "❌ Please run as root or with sudo"
        exit 1
    fi
    
    # Check if Docker is installed
    if ! command -v docker &> /dev/null; then
        print_color $RED "❌ Docker is not installed. Please install Docker first."
        exit 1
    fi
    
    # Check if Docker Compose is installed
    if ! command -v docker-compose &> /dev/null; then
        print_color $RED "❌ Docker Compose is not installed. Please install Docker Compose first."
        exit 1
    fi
    
    # Check if Nginx is installed
    if ! command -v nginx &> /dev/null; then
        print_color $RED "❌ Nginx is not installed. Please install Nginx first."
        exit 1
    fi
    
    # Check if Certbot is installed
    if ! command -v certbot &> /dev/null; then
        print_color $YELLOW "📦 Installing Certbot..."
        apt update
        apt install -y certbot python3-certbot-nginx
    fi
    
    print_color $GREEN "✅ Prerequisites ready!"
}

get_configuration() {
    print_banner
    print_color $YELLOW "🌐 Configuration Setup"
    echo
    
    # Get domain
    read -p "Enter domain for Selenium Grid (e.g., selenium.yourdomain.com): " SELENIUM_DOMAIN
    if [ -z "$SELENIUM_DOMAIN" ]; then
        print_color $RED "❌ Domain cannot be empty"
        get_configuration
    fi
    
    # Get email for SSL
    read -p "Enter email for SSL certificate: " SSL_EMAIL
    if [ -z "$SSL_EMAIL" ]; then
        print_color $RED "❌ Email cannot be empty"
        get_configuration
    fi
    
    # Get Grid configuration
    read -p "Enter number of Chrome nodes (default: 2): " CHROME_NODES
    CHROME_NODES=${CHROME_NODES:-2}
    
    read -p "Enter number of Firefox nodes (default: 2): " FIREFOX_NODES
    FIREFOX_NODES=${FIREFOX_NODES:-2}
    
    read -p "Enter number of Edge nodes (default: 1): " EDGE_NODES
    EDGE_NODES=${EDGE_NODES:-1}
    
    # Check port conflicts for Selenium services
    SELENIUM_HUB_PORT=4444
    SELENIUM_VNC_BASE_PORT=5900
    SELENIUM_NODE_BASE_PORT=5555
    
    # Find available ports
    while netstat -tlnp | grep ":$SELENIUM_HUB_PORT " > /dev/null 2>&1; do
        SELENIUM_HUB_PORT=$((SELENIUM_HUB_PORT + 1))
    done
    
    # Check VNC ports range
    for ((i=0; i<10; i++)); do
        VNC_PORT=$((SELENIUM_VNC_BASE_PORT + i))
        if netstat -tlnp | grep ":$VNC_PORT " > /dev/null 2>&1; then
            SELENIUM_VNC_BASE_PORT=$((SELENIUM_VNC_BASE_PORT + 10))
            break
        fi
    done
    
    print_color $GREEN "✅ Configuration complete!"
    print_color $BLUE "   Domain: $SELENIUM_DOMAIN"
    print_color $BLUE "   Hub Port: $SELENIUM_HUB_PORT"
    print_color $BLUE "   Chrome Nodes: $CHROME_NODES"
    print_color $BLUE "   Firefox Nodes: $FIREFOX_NODES"
    print_color $BLUE "   Edge Nodes: $EDGE_NODES"
    print_color $BLUE "   VNC Base Port: $SELENIUM_VNC_BASE_PORT"
    sleep 2
}

install_selenium() {
    print_color $BLUE "📁 Creating directory structure..."
    mkdir -p /opt/selenium-grid/{config,videos,downloads,uploads}
    
    cd /opt/selenium-grid
    
    print_color $BLUE "📝 Creating Selenium Grid configuration..."
    
    # Create hub configuration
    cat > config/hub-config.json << EOF
{
  "port": 4444,
  "newSessionWaitTimeout": -1,
  "servlets": [],
  "prioritizer": null,
  "capabilityMatcher": "org.openqa.grid.internal.utils.DefaultCapabilityMatcher",
  "registry": "org.openqa.grid.internal.DefaultGridRegistry",
  "throwOnCapabilityNotPresent": true,
  "cleanUpCycle": 5000,
  "role": "hub",
  "debug": false,
  "browserTimeout": 120,
  "timeout": 30
}
EOF

    # Create node configuration template
    cat > config/node-config.json << EOF
{
  "capabilities": [
    {
      "browserName": "chrome",
      "maxInstances": 1,
      "seleniumProtocol": "WebDriver"
    }
  ],
  "proxy": "org.openqa.grid.selenium.proxy.DefaultRemoteProxy",
  "maxSession": 1,
  "port": 5555,
  "register": true,
  "registerCycle": 5000,
  "hub": "http://selenium-hub:4444",
  "nodeStatusCheckTimeout": 5000,
  "nodePolling": 5000,
  "role": "node",
  "unregisterIfStillDownAfter": 60000,
  "downPollingLimit": 2,
  "debug": false,
  "servlets": [],
  "withoutServlets": [],
  "custom": {}
}
EOF

    print_color $BLUE "🐳 Creating Docker Compose configuration..."
    cat > docker-compose.yml << EOF
version: '3.8'

services:
  selenium-hub:
    image: selenium/hub:4.15.0
    container_name: selenium-hub
    restart: unless-stopped
    ports:
      - "127.0.0.1:${SELENIUM_HUB_PORT}:4444"
    environment:
      - GRID_MAX_SESSION=16
      - GRID_BROWSER_TIMEOUT=120
      - GRID_TIMEOUT=30
      - GRID_NEW_SESSION_WAIT_TIMEOUT=60
    volumes:
      - ./config:/opt/selenium/config
    networks:
      - selenium-network
    healthcheck:
      test: ["CMD-SHELL", "curl -f http://localhost:4444/wd/hub/status || exit 1"]
      interval: 30s
      timeout: 10s
      retries: 3

EOF

    # Generate Chrome nodes
    for ((i=1; i<=CHROME_NODES; i++)); do
        VNC_PORT=$((SELENIUM_VNC_BASE_PORT + i - 1))
        cat >> docker-compose.yml << EOF
  chrome-node-${i}:
    image: selenium/node-chrome:4.15.0
    container_name: chrome-node-${i}
    restart: unless-stopped
    ports:
      - "127.0.0.1:${VNC_PORT}:5900"
    environment:
      - HUB_HOST=selenium-hub
      - HUB_PORT=4444
      - NODE_MAX_INSTANCES=1
      - NODE_MAX_SESSION=1
      - SE_EVENT_BUS_HOST=selenium-hub
      - SE_EVENT_BUS_PUBLISH_PORT=4442
      - SE_EVENT_BUS_SUBSCRIBE_PORT=4443
      - SE_VNC_PASSWORD=selenium123
      - SE_SCREEN_WIDTH=1920
      - SE_SCREEN_HEIGHT=1080
    volumes:
      - ./downloads:/home/seluser/Downloads
      - ./uploads:/home/seluser/uploads
      - /dev/shm:/dev/shm
    depends_on:
      - selenium-hub
    networks:
      - selenium-network
    shm_size: 2gb

EOF
    done

    # Generate Firefox nodes
    for ((i=1; i<=FIREFOX_NODES; i++)); do
        VNC_PORT=$((SELENIUM_VNC_BASE_PORT + CHROME_NODES + i - 1))
        cat >> docker-compose.yml << EOF
  firefox-node-${i}:
    image: selenium/node-firefox:4.15.0
    container_name: firefox-node-${i}
    restart: unless-stopped
    ports:
      - "127.0.0.1:${VNC_PORT}:5900"
    environment:
      - HUB_HOST=selenium-hub
      - HUB_PORT=4444
      - NODE_MAX_INSTANCES=1
      - NODE_MAX_SESSION=1
      - SE_EVENT_BUS_HOST=selenium-hub
      - SE_EVENT_BUS_PUBLISH_PORT=4442
      - SE_EVENT_BUS_SUBSCRIBE_PORT=4443
      - SE_VNC_PASSWORD=selenium123
      - SE_SCREEN_WIDTH=1920
      - SE_SCREEN_HEIGHT=1080
    volumes:
      - ./downloads:/home/seluser/Downloads
      - ./uploads:/home/seluser/uploads
      - /dev/shm:/dev/shm
    depends_on:
      - selenium-hub
    networks:
      - selenium-network
    shm_size: 2gb

EOF
    done

    # Generate Edge nodes
    for ((i=1; i<=EDGE_NODES; i++)); do
        VNC_PORT=$((SELENIUM_VNC_BASE_PORT + CHROME_NODES + FIREFOX_NODES + i - 1))
        cat >> docker-compose.yml << EOF
  edge-node-${i}:
    image: selenium/node-edge:4.15.0
    container_name: edge-node-${i}
    restart: unless-stopped
    ports:
      - "127.0.0.1:${VNC_PORT}:5900"
    environment:
      - HUB_HOST=selenium-hub
      - HUB_PORT=4444
      - NODE_MAX_INSTANCES=1
      - NODE_MAX_SESSION=1
      - SE_EVENT_BUS_HOST=selenium-hub
      - SE_EVENT_BUS_PUBLISH_PORT=4442
      - SE_EVENT_BUS_SUBSCRIBE_PORT=4443
      - SE_VNC_PASSWORD=selenium123
      - SE_SCREEN_WIDTH=1920
      - SE_SCREEN_HEIGHT=1080
    volumes:
      - ./downloads:/home/seluser/Downloads
      - ./uploads:/home/seluser/uploads
      - /dev/shm:/dev/shm
    depends_on:
      - selenium-hub
    networks:
      - selenium-network
    shm_size: 2gb

EOF
    done

    # Add network configuration
    cat >> docker-compose.yml << EOF

networks:
  selenium-network:
    driver: bridge
    name: selenium-network
EOF

    # Create environment file
    cat > .env << EOF
SELENIUM_DOMAIN=${SELENIUM_DOMAIN}
SELENIUM_HUB_PORT=${SELENIUM_HUB_PORT}
SELENIUM_VNC_BASE_PORT=${SELENIUM_VNC_BASE_PORT}
CHROME_NODES=${CHROME_NODES}
FIREFOX_NODES=${FIREFOX_NODES}
EDGE_NODES=${EDGE_NODES}
SSL_EMAIL=${SSL_EMAIL}
EOF

    print_color $BLUE "🚀 Starting Selenium Grid..."
    docker-compose up -d
    
    print_color $YELLOW "⏳ Waiting for Selenium Grid to initialize..."
    sleep 60
    
    # Check if hub is running
    if docker-compose ps | grep -q "selenium-hub.*Up"; then
        print_color $GREEN "✅ Selenium Hub is running"
        
        # Check if hub responds
        local_test=$(curl -s -o /dev/null -w "%{http_code}" http://127.0.0.1:${SELENIUM_HUB_PORT}/wd/hub/status 2>/dev/null || echo "000")
        if [ "$local_test" = "200" ]; then
            print_color $GREEN "✅ Selenium Hub is responding locally ($local_test)"
        else
            print_color $YELLOW "⚠️  Selenium Hub response: $local_test (may need more time)"
        fi
    else
        print_color $RED "❌ Selenium Hub failed to start"
        docker-compose logs selenium-hub | tail -20
        exit 1
    fi
    
    # Check nodes
    RUNNING_NODES=$(docker-compose ps | grep -c "node.*Up" || echo "0")
    TOTAL_NODES=$((CHROME_NODES + FIREFOX_NODES + EDGE_NODES))
    print_color $BLUE "📊 Running nodes: $RUNNING_NODES/$TOTAL_NODES"
}

configure_nginx() {
    print_color $BLUE "🌐 Configuring Nginx..."
    
    # Check if site already exists
    if [ -f "/etc/nginx/sites-available/${SELENIUM_DOMAIN}" ]; then
        print_color $YELLOW "⚠️  Nginx site ${SELENIUM_DOMAIN} already exists. Creating backup..."
        cp "/etc/nginx/sites-available/${SELENIUM_DOMAIN}" "/etc/nginx/sites-available/${SELENIUM_DOMAIN}.backup.$(date +%Y%m%d-%H%M%S)"
    fi
    
    # Initial HTTP configuration
    cat > /etc/nginx/sites-available/${SELENIUM_DOMAIN} << EOF
server {
    listen 80;
    server_name ${SELENIUM_DOMAIN};
    
    location /.well-known/acme-challenge/ {
        root /var/www/html;
    }
    
    location / {
        return 301 https://\$server_name\$request_uri;
    }
}
EOF

    ln -sf /etc/nginx/sites-available/${SELENIUM_DOMAIN} /etc/nginx/sites-enabled/
    nginx -t && systemctl reload nginx
    
    print_color $BLUE "🔒 Obtaining SSL certificate..."
    certbot --nginx -d ${SELENIUM_DOMAIN} --email ${SSL_EMAIL} --agree-tos --non-interactive --redirect
    
    # Final HTTPS configuration with Selenium-specific settings
    cat > /etc/nginx/sites-available/${SELENIUM_DOMAIN} << EOF
server {
    listen 80;
    server_name ${SELENIUM_DOMAIN};
    return 301 https://\$server_name\$request_uri;
}

server {
    listen 443 ssl http2;
    server_name ${SELENIUM_DOMAIN};

    ssl_certificate /etc/letsencrypt/live/${SELENIUM_DOMAIN}/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/${SELENIUM_DOMAIN}/privkey.pem;
    
    ssl_protocols TLSv1.2 TLSv1.3;
    ssl_prefer_server_ciphers off;
    ssl_session_timeout 1d;

    add_header Strict-Transport-Security "max-age=31536000" always;
    add_header X-Content-Type-Options nosniff;
    add_header X-Frame-Options SAMEORIGIN;
    add_header X-XSS-Protection "1; mode=block";

    access_log /var/log/nginx/${SELENIUM_DOMAIN}_access.log;
    error_log /var/log/nginx/${SELENIUM_DOMAIN}_error.log;

    # Increase timeouts for long-running tests
    proxy_connect_timeout 300s;
    proxy_send_timeout 300s;
    proxy_read_timeout 300s;
    client_max_body_size 100M;

    # Main Selenium Grid Hub
    location / {
        proxy_pass http://127.0.0.1:${SELENIUM_HUB_PORT};
        proxy_set_header Host \$http_host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto \$scheme;
        proxy_redirect off;
        
        # WebSocket support for live view
        proxy_http_version 1.1;
        proxy_set_header Upgrade \$http_upgrade;
        proxy_set_header Connection "upgrade";
    }

    # WebDriver endpoints
    location /wd/ {
        proxy_pass http://127.0.0.1:${SELENIUM_HUB_PORT};
        proxy_set_header Host \$http_host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto \$scheme;
        proxy_redirect off;
        
        # Disable buffering for real-time communication
        proxy_buffering off;
        proxy_request_buffering off;
    }

    # Grid console and API
    location /grid/ {
        proxy_pass http://127.0.0.1:${SELENIUM_HUB_PORT};
        proxy_set_header Host \$http_host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto \$scheme;
        proxy_redirect off;
    }

    # Static assets
    location ~* \.(css|js|png|jpg|jpeg|gif|ico|svg|woff|woff2|ttf|eot)\$ {
        proxy_pass http://127.0.0.1:${SELENIUM_HUB_PORT};
        proxy_set_header Host \$http_host;
        
        expires 1d;
        add_header Cache-Control "public";
    }

    # File downloads location
    location /downloads/ {
        alias /opt/selenium-grid/downloads/;
        autoindex on;
        autoindex_exact_size off;
        autoindex_localtime on;
    }
}
EOF

    nginx -t && systemctl reload nginx
    print_color $GREEN "✅ Nginx configured with SSL and Selenium-specific settings"
}

create_management_script() {
    print_color $BLUE "📝 Creating management script..."
    cat > /opt/selenium-grid/manage-selenium.sh << 'EOF'
#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

case "$1" in
    start)
        echo "Starting Selenium Grid..."
        docker-compose up -d
        echo "Waiting for services to initialize..."
        sleep 30
        ;;
    stop)
        echo "Stopping Selenium Grid..."
        docker-compose down
        ;;
    restart)
        echo "Restarting Selenium Grid..."
        docker-compose restart
        ;;
    logs)
        service=${2:-}
        if [ -z "$service" ]; then
            echo "Showing all logs..."
            docker-compose logs -f
        else
            case $service in
                hub)
                    docker-compose logs -f selenium-hub
                    ;;
                chrome|chrome-*)
                    if [[ "$service" == "chrome" ]]; then
                        docker-compose logs -f chrome-node-1
                    else
                        docker-compose logs -f "$service"
                    fi
                    ;;
                firefox|firefox-*)
                    if [[ "$service" == "firefox" ]]; then
                        docker-compose logs -f firefox-node-1
                    else
                        docker-compose logs -f "$service"
                    fi
                    ;;
                edge|edge-*)
                    if [[ "$service" == "edge" ]]; then
                        docker-compose logs -f edge-node-1
                    else
                        docker-compose logs -f "$service"
                    fi
                    ;;
                *)
                    echo "Unknown service. Use: hub, chrome, firefox, edge, or specific container name"
                    ;;
            esac
        fi
        ;;
    status)
        echo "Selenium Grid status:"
        docker-compose ps
        echo
        echo "Grid Console: https://$(grep SELENIUM_DOMAIN .env | cut -d= -f2)/"
        echo "Hub Status: https://$(grep SELENIUM_DOMAIN .env | cut -d= -f2)/wd/hub/status"
        echo "Sessions: https://$(grep SELENIUM_DOMAIN .env | cut -d= -f2)/wd/hub/sessions"
        echo
        echo "VNC Access (password: selenium123):"
        CHROME_NODES=$(grep CHROME_NODES .env | cut -d= -f2)
        FIREFOX_NODES=$(grep FIREFOX_NODES .env | cut -d= -f2)
        EDGE_NODES=$(grep EDGE_NODES .env | cut -d= -f2)
        VNC_BASE=$(grep SELENIUM_VNC_BASE_PORT .env | cut -d= -f2)
        
        echo "Chrome nodes:"
        for ((i=1; i<=CHROME_NODES; i++)); do
            VNC_PORT=$((VNC_BASE + i - 1))
            echo "  Chrome Node $i: localhost:$VNC_PORT"
        done
        
        echo "Firefox nodes:"
        for ((i=1; i<=FIREFOX_NODES; i++)); do
            VNC_PORT=$((VNC_BASE + CHROME_NODES + i - 1))
            echo "  Firefox Node $i: localhost:$VNC_PORT"
        done
        
        echo "Edge nodes:"
        for ((i=1; i<=EDGE_NODES; i++)); do
            VNC_PORT=$((VNC_BASE + CHROME_NODES + FIREFOX_NODES + i - 1))
            echo "  Edge Node $i: localhost:$VNC_PORT"
        done
        ;;
    backup)
        echo "Creating backup..."
        tar -czf "selenium-backup-$(date +%Y%m%d-%H%M%S).tar.gz" \
            docker-compose.yml .env config/ downloads/ uploads/ \
            --exclude=downloads/* --exclude=uploads/*
        echo "Backup created (excluding download/upload files)"
        ;;
    update)
        echo "Updating Selenium Grid images..."
        docker-compose pull
        docker-compose up -d
        ;;
    scale)
        if [ -z "$2" ] || [ -z "$3" ]; then
            echo "Usage: $0 scale <browser> <count>"
            echo "Example: $0 scale chrome 3"
            echo "Browsers: chrome, firefox, edge"
            exit 1
        fi
        
        browser=$2
        count=$3
        
        case $browser in
            chrome)
                docker-compose up -d --scale chrome-node=$count
                ;;
            firefox)
                docker-compose up -d --scale firefox-node=$count
                ;;
            edge)
                docker-compose up -d --scale edge-node=$count
                ;;
            *)
                echo "Unknown browser. Use: chrome, firefox, edge"
                exit 1
                ;;
        esac
        ;;
    test)
        echo "Testing Selenium Grid connectivity..."
        HUB_PORT=$(grep SELENIUM_HUB_PORT .env | cut -d= -f2)
        
        echo "Checking hub status..."
        curl -s "http://127.0.0.1:${HUB_PORT}/wd/hub/status" | jq '.' 2>/dev/null || \
        curl -s "http://127.0.0.1:${HUB_PORT}/wd/hub/status"
        
        echo -e "\nChecking available nodes..."
        curl -s "http://127.0.0.1:${HUB_PORT}/grid/api/hub" | jq '.slotCounts' 2>/dev/null || \
        curl -s "http://127.0.0.1:${HUB_PORT}/grid/api/hub"
        ;;
    cleanup)
        echo "Cleaning up old downloads and temporary files..."
        find ./downloads -type f -mtime +7 -delete 2>/dev/null || true
        find ./uploads -type f -mtime +7 -delete 2>/dev/null || true
        docker system prune -f
        echo "Cleanup completed"
        ;;
    *)
        echo "Usage: $0 {start|stop|restart|logs [service]|status|backup|update|scale <browser> <count>|test|cleanup}"
        echo
        echo "Services for logs: hub, chrome, firefox, edge"
        echo "Browsers for scale: chrome, firefox, edge"
        exit 1
        ;;
esac
EOF

    chmod +x /opt/selenium-grid/manage-selenium.sh
}

create_test_script() {
    print_color $BLUE "📝 Creating test script..."
    cat > /opt/selenium-grid/test-selenium.py << 'EOF'
#!/usr/bin/env python3
"""
Simple Selenium Grid test script
Requires: pip install selenium
"""

import sys
import time
from selenium import webdriver
from selenium.webdriver.common.desired_capabilities import DesiredCapabilities
from selenium.webdriver.common.by import By
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC

def test_browser(browser_name, grid_url):
    """Test a specific browser on the Selenium Grid"""
    print(f"Testing {browser_name}...")
    
    # Set up desired capabilities
    if browser_name.lower() == 'chrome':
        capabilities = DesiredCapabilities.CHROME
    elif browser_name.lower() == 'firefox':
        capabilities = DesiredCapabilities.FIREFOX
    elif browser_name.lower() == 'edge':
        capabilities = DesiredCapabilities.EDGE
    else:
        print(f"Unknown browser: {browser_name}")
        return False
    
    try:
        # Create remote webdriver
        driver = webdriver.Remote(
            command_executor=grid_url,
            desired_capabilities=capabilities
        )
        
        # Navigate to a test page
        driver.get("https://www.google.com")
        
        # Wait for page to load and check title
        WebDriverWait(driver, 10).until(
            EC.title_contains("Google")
        )
        
        print(f"✅ {browser_name}: Successfully loaded Google (Title: {driver.title})")
        
        # Take a screenshot
        driver.save_screenshot(f"/opt/selenium-grid/downloads/test_{browser_name}_{int(time.time())}.png")
        
        # Perform a simple search
        search_box = driver.find_element(By.NAME, "q")
        search_box.send_keys("Selenium WebDriver")
        search_box.submit()
        
        # Wait for results
        WebDriverWait(driver, 10).until(
            EC.presence_of_element_located((By.ID, "search"))
        )
        
        print(f"✅ {browser_name}: Successfully performed search")
        
        driver.quit()
        return True
        
    except Exception as e:
        print(f"❌ {browser_name}: Error - {str(e)}")
        try:
            driver.quit()
        except:
            pass
        return False

def main():
    """Main test function"""
    grid_url = "http://localhost:4444/wd/hub"
    
    if len(sys.argv) > 1:
        # Test specific browser
        browser = sys.argv[1]
        test_browser(browser, grid_url)
    else:
        # Test all browsers
        browsers = ['chrome', 'firefox', 'edge']
        results = {}
        
        print("Testing Selenium Grid with all browsers...")
        print("=" * 50)
        
        for browser in browsers:
            results[browser] = test_browser(browser, grid_url)
            time.sleep(2)  # Brief pause between tests
        
        print("\n" + "=" * 50)
        print("Test Results:")
        for browser, success in results.items():
            status = "✅ PASS" if success else "❌ FAIL"
            print(f"{browser.capitalize()}: {status}")

if __name__ == "__main__":
    main()
EOF

    chmod +x /opt/selenium-grid/test-selenium.py
}

# Main installation flow
main() {
    print_banner
    check_prerequisites
    get_configuration
    install_selenium
    configure_nginx
    create_management_script
    create_test_script
    
    print_color $GREEN "✅ Selenium Grid installation completed!"
    echo
    print_color $CYAN "======================================"
    print_color $CYAN "    Installation Complete!"
    print_color $CYAN "======================================"
    echo
    print_color $YELLOW "📍 Access Information:"
    print_color $BLUE "   Grid Console: https://${SELENIUM_DOMAIN}"
    print_color $BLUE "   Hub Status: https://${SELENIUM_DOMAIN}/wd/hub/status"
    print_color $BLUE "   Grid API: https://${SELENIUM_DOMAIN}/grid/api/hub"
    print_color $BLUE "   WebDriver Hub: https://${SELENIUM_DOMAIN}/wd/hub"
    echo
    print_color $YELLOW "🔧 Management Commands:"
    print_color $BLUE "   /opt/selenium-grid/manage-selenium.sh start"
    print_color $BLUE "   /opt/selenium-grid/manage-selenium.sh stop"
    print_color $BLUE "   /opt/selenium-grid/manage-selenium.sh restart"
    print_color $BLUE "   /opt/selenium-grid/manage-selenium.sh status"
    print_color $BLUE "   /opt/selenium-grid/manage-selenium.sh logs [service]"
    print_color $BLUE "   /opt/selenium-grid/manage-selenium.sh test"
    print_color $BLUE "   /opt/selenium-grid/manage-selenium.sh scale chrome 5"
    echo
    print_color $YELLOW "📊 Grid Configuration:"
    print_color $BLUE "   Chrome Nodes: ${CHROME_NODES}"
    print_color $BLUE "   Firefox Nodes: ${FIREFOX_NODES}"
    print_color $BLUE "   Edge Nodes: ${EDGE_NODES}"
    print_color $BLUE "   VNC Password: selenium123"
    echo
    print_color $YELLOW "🖥️ VNC Access (for visual debugging):"
    VNC_PORT=$SELENIUM_VNC_BASE_PORT
    for ((i=1; i<=CHROME_NODES; i++)); do
        print_color $BLUE "   Chrome Node $i: localhost:$VNC_PORT"
        VNC_PORT=$((VNC_PORT + 1))
    done
    for ((i=1; i<=FIREFOX_NODES; i++)); do
        print_color $BLUE "   Firefox Node $i: localhost:$VNC_PORT"
        VNC_PORT=$((VNC_PORT + 1))
    done
    for ((i=1; i<=EDGE_NODES; i++)); do
        print_color $BLUE "   Edge Node $i: localhost:$VNC_PORT"
        VNC_PORT=$((VNC_PORT + 1))
    done
    echo
    print_color $YELLOW "📁 Configuration Location:"
    print_color $BLUE "   /opt/selenium-grid/"
    echo
    print_color $YELLOW "🧪 Testing:"
    print_color $BLUE "   Test Grid: /opt/selenium-grid/manage-selenium.sh test"
    print_color $BLUE "   Python Test: python3 /opt/selenium-grid/test-selenium.py"
    print_color $BLUE "   Test Specific Browser: python3 /opt/selenium-grid/test-selenium.py chrome"
    echo
    print_color $YELLOW "🔧 Important Notes:"
    print_color $BLUE "   • Grid uses unique ports to avoid conflicts with other services"
    print_color $BLUE "   • VNC password is 'selenium123' for visual debugging"
    print_color $BLUE "   • Downloads are saved to /opt/selenium-grid/downloads/"
    print_color $BLUE "   • Upload files to /opt/selenium-grid/uploads/ for tests"
    print_color $BLUE "   • Use 'manage-selenium.sh cleanup' to remove old files"
    echo
    print_color $GREEN "🌐 Access Selenium Grid at: https://${SELENIUM_DOMAIN}"
    print_color $GREEN "🔗 WebDriver endpoint: https://${SELENIUM_DOMAIN}/wd/hub"
    echo
    print_color $YELLOW "📚 Example WebDriver usage:"
    print_color $CYAN "   from selenium import webdriver"
    print_color $CYAN "   from selenium.webdriver.common.desired_capabilities import DesiredCapabilities"
    print_color $CYAN "   "
    print_color $CYAN "   driver = webdriver.Remote("
    print_color $CYAN "       command_executor='https://${SELENIUM_DOMAIN}/wd/hub',"
    print_color $CYAN "       desired_capabilities=DesiredCapabilities.CHROME"
    print_color $CYAN "   )"
    print_color $CYAN "   driver.get('https://example.com')"
    print_color $CYAN "   driver.quit()"
    echo
    print_color $YELLOW "📁 Script Developer:"
    print_color $YELLOW "📁 DefendX1 Team"
    print_color $YELLOW "📁 https://defendx1.com/"
}

# Run main function
main "$@"
