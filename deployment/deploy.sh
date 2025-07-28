#!/bin/bash

# Deployment script for website
# Usage: ./deploy.sh

# Configuration
VPS_USER="your-username"
VPS_HOST="your-vps-ip"
DOMAIN="your-domain.com"
REMOTE_PATH="/var/www/$DOMAIN"
LOCAL_PATH="../src/"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${YELLOW}Starting deployment to $VPS_HOST${NC}"

# Check if local source exists
if [ ! -d "$LOCAL_PATH" ]; then
    echo -e "${RED}Error: Source directory $LOCAL_PATH not found${NC}"
    exit 1
fi

# Create remote directory if it doesn't exist
echo -e "${GREEN}Creating remote directory...${NC}"
ssh $VPS_USER@$VPS_HOST "sudo mkdir -p $REMOTE_PATH && sudo chown -R $VPS_USER:www-data $REMOTE_PATH"

# Sync files using rsync
echo -e "${GREEN}Syncing files...${NC}"
rsync -avz --delete \
    --exclude '.git' \
    --exclude '.gitignore' \
    --exclude 'node_modules' \
    --exclude '.DS_Store' \
    $LOCAL_PATH $VPS_USER@$VPS_HOST:$REMOTE_PATH/

# Set proper permissions
echo -e "${GREEN}Setting permissions...${NC}"
ssh $VPS_USER@$VPS_HOST "sudo chown -R www-data:www-data $REMOTE_PATH && sudo chmod -R 755 $REMOTE_PATH"

# Test Nginx configuration
echo -e "${GREEN}Testing Nginx configuration...${NC}"
ssh $VPS_USER@$VPS_HOST "sudo nginx -t"

if [ $? -eq 0 ]; then
    # Reload Nginx
    echo -e "${GREEN}Reloading Nginx...${NC}"
    ssh $VPS_USER@$VPS_HOST "sudo systemctl reload nginx"
    echo -e "${GREEN}Deployment complete!${NC}"
    echo -e "${GREEN}Your site should be live at https://$DOMAIN${NC}"
else
    echo -e "${RED}Nginx configuration test failed. Please check your nginx.conf${NC}"
    exit 1
fi

# Optional: Clear Cloudflare cache
echo -e "${YELLOW}Don't forget to purge Cloudflare cache if needed!${NC}"