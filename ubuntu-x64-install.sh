#!/bin/bash

# This script is for installing Astro on Ubuntu Server
# System Requirements:
# - Ubuntu Server 24 LTS or higher
# - At least 1GB RAM
# - At least 10GB free disk space
# - Root privileges required

# Exit on error to ensure script stops if any command fails
set -e

# Function to check and install required tools
check_and_install_tools() {
    echo "----> [ASTRO-INSTALL] Checking required tools..."
    local tools=("curl" "wget" "unzip" "apt-get")
    local missing_tools=()

    # Check which tools are missing
    for tool in "${tools[@]}"; do
        if ! command -v "$tool" &> /dev/null; then
            missing_tools+=("$tool")
        fi
    done

    # Install missing tools if any
    if [ ${#missing_tools[@]} -ne 0 ]; then
        echo "----> [ASTRO-INSTALL] Installing missing tools: ${missing_tools[*]}"
        apt-get update
        apt-get install -y "${missing_tools[@]}"
    fi
}

# Function to validate IP address
validate_ip() {
    local ip=$1
    
    # Check if empty
    if [ -z "$ip" ]; then
        return 1
    fi
    
    # Check basic format: should have exactly 3 dots
    if [ "$(echo "$ip" | tr -cd '.' | wc -c)" -ne 3 ]; then
        return 1
    fi
    
    # Split IP into parts and validate each part
    IFS='.' read -r part1 part2 part3 part4 <<< "$ip"
    
    # Check each part is a number between 0-255
    for part in "$part1" "$part2" "$part3" "$part4"; do
        # Check if part is numeric
        if ! [[ "$part" =~ ^[0-9]+$ ]]; then
            return 1
        fi
        # Check range 0-255
        if [ "$part" -lt 0 ] || [ "$part" -gt 255 ]; then
            return 1
        fi
        # Check no leading zeros (except for "0")
        if [ "${#part}" -gt 1 ] && [ "${part:0:1}" = "0" ]; then
            return 1
        fi
    done
    
    return 0
}

# 可靠的IP获取函数
get_server_ip() {
    # 尝试自动获取公网IP
    auto_ip=$(curl -s https://api.ipify.org || true)
    
    if validate_ip "$auto_ip"; then
        echo "----> [ASTRO-INSTALL] Detected public IP: $auto_ip" > /dev/tty
        
        # 询问是否使用自动获取的IP
        read -p $'\n----> [ASTRO-INSTALL] Use this IP? [Y/n] ' confirm < /dev/tty
        if [[ -z "$confirm" || "$confirm" =~ ^[Yy] ]]; then
            SERVER_IP="$auto_ip"
            return
        fi
    fi
    
    # 手动输入
    while true; do
        echo -e "\n----> [ASTRO-INSTALL] Please enter your server's public IP address" > /dev/tty
        read -p "IP: " SERVER_IP < /dev/tty
        
        if validate_ip "$SERVER_IP"; then
            break
        else
            echo "ERROR: Invalid IP format (e.g. 192.168.1.1)" > /dev/tty
        fi
    done
}

echo "----> [ASTRO-INSTALL] Starting Astro installation..." > /dev/tty

# === 主流程 ===
get_server_ip

# Check if running with root privileges
# This script needs to be run with sudo on Ubuntu Server
if [ "$EUID" -ne 0 ]; then 
    echo "----> [ASTRO-INSTALL] ERROR: Please run this script with sudo"
    exit 1
fi

# Check and install required tools
check_and_install_tools

# 1. Install Node.js 23.x
# Using NodeSource repository to install the latest Node.js 23.x version
echo "----> [ASTRO-INSTALL] Installing Node.js 23.x..."
curl -sL https://deb.nodesource.com/setup_23.x | bash -
sudo apt-get install --allow-downgrades -y nodejs=23.11.1-1nodesource1

# Verify Node.js installation
node_version=$(node -v)
echo "----> [ASTRO-INSTALL] Node.js version: $node_version"

# 2. Install global dependencies
# Installing required tools for running Astro:
# - pm2: for process management and daemon
# - bytenode: for JavaScript compilation
# - yarn: package manager
echo "----> [ASTRO-INSTALL] Installing global dependencies..."
npm install -g pm2 bytenode yarn
echo "----> [ASTRO-INSTALL] Installing pm2-logrotate..."
pm2 install pm2-logrotate

# 3. Download and extract latest version
# Using GitHub API to get the latest release download link
echo "----> [ASTRO-INSTALL] Downloading latest version..."
LATEST_RELEASE_URL=$(curl -s https://api.github.com/repos/astro-btc/astro/releases/latest | grep "browser_download_url.*zip" | cut -d '"' -f 4)
RELEASE_FILENAME=$(basename "$LATEST_RELEASE_URL")

# Download the file
wget "$LATEST_RELEASE_URL"

# Extract files to current directory
echo "----> [ASTRO-INSTALL] Extracting files..."
unzip "$RELEASE_FILENAME"

# Fix permissions for extracted directories
echo "----> [ASTRO-INSTALL] Fixing file permissions..."
chmod -R 755 astro-core astro-server astro-admin 2>/dev/null || true
chown -R $SUDO_USER:$SUDO_USER astro-core astro-server astro-admin 2>/dev/null || true

# Clean up downloaded zip file to save space
rm "$RELEASE_FILENAME"

# 4. Setup astro-core
echo "----> [ASTRO-INSTALL] Setting up astro-core..."

# Enter project directory
cd astro-core || exit 1

# Install dependencies excluding better-sqlite3
echo "----> [ASTRO-INSTALL] Installing astro-core dependencies (excluding better-sqlite3)..."
yarn install --ignore-scripts

# Download and install precompiled better-sqlite3
echo "----> [ASTRO-INSTALL] Downloading precompiled better-sqlite3..."
cd node_modules || exit 1

# Download the precompiled package
wget -O bs3-ubuntu-x64.gz "https://raw.githubusercontent.com/astro-btc/astro/refs/heads/main/bs3-ubuntu-x64.gz"

# Extract to better-sqlite3 directory
echo "----> [ASTRO-INSTALL] Extracting better-sqlite3..."
mkdir -p better-sqlite3
tar -xzf bs3-ubuntu-x64.gz

# Clean up downloaded file
rm bs3-ubuntu-x64.gz

# Return to astro-core directory
cd ..
pm2 start pm2.config.js
echo "----> [ASTRO-INSTALL] astro-core setup completed"

# 5. Configure astro-server
echo "----> [ASTRO-INSTALL] Configuring astro-server..."
cd ../astro-server || exit 1

# Update .env file with the IP address
if [ -f .env ]; then
    sed -i "s/ALLOWED_DOMAIN=.*/ALLOWED_DOMAIN=$SERVER_IP/" .env
    echo "----> [ASTRO-INSTALL] Updated .env file with IP: $SERVER_IP"
else
    echo "----> [ASTRO-INSTALL] ERROR: .env file not found in astro-server directory"
    exit 1
fi

# Install dependencies and start server
echo "----> [ASTRO-INSTALL] Installing astro-server dependencies and starting service..."
yarn
pm2 start pm2.config.js

# 6. Setup PM2 startup
echo "----> [ASTRO-INSTALL] Setting up PM2 startup..."
pm2 startup
pm2 save

echo "----> [ASTRO-INSTALL] Installation completed!"
echo "----> [ASTRO-INSTALL] 打开浏览器访问: https://$SERVER_IP:12345/change-after-install/"
echo "----> [ASTRO-INSTALL] 默认密码：Astro321@"
echo "----> [ASTRO-INSTALL] 默认Google二次认证码：GRY5ZVAXTSYZFXFUSP7BH5QEYTEMZU42 （需要手动导入Google Authenticator）"
