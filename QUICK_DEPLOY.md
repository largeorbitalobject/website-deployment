# Quick Deploy Guide

## Option 1: Direct Transfer (Fastest)

From this container, run:
```bash
# Replace with your actual VPS details
scp -r /home/orbital/experiments/website-deployment username@your-vps-ip:~/
```

Then on your VPS:
```bash
# Move to web directory
sudo mkdir -p /var/www/your-domain.com
sudo cp -r ~/website-deployment/src/* /var/www/your-domain.com/
sudo chown -R www-data:www-data /var/www/your-domain.com
```

## Option 2: Using Git (Recommended for updates)

1. **On this container**, initialize git:
```bash
cd /home/orbital/experiments/website-deployment
git init
git add .
git commit -m "Initial commit"
```

2. **On your VPS**, clone it:
```bash
# First, push to GitHub/GitLab (create a repo first)
git remote add origin https://github.com/yourusername/your-repo.git
git push -u origin main

# Then on VPS:
cd /var/www
sudo git clone https://github.com/yourusername/your-repo.git your-domain.com
sudo chown -R www-data:www-data your-domain.com
```

## Option 3: Quick Archive Transfer

Create archive here:
```bash
cd /home/orbital/experiments
tar -czf website-deployment.tar.gz website-deployment/
```

Transfer to VPS:
```bash
scp website-deployment.tar.gz username@your-vps-ip:~/
```

Extract on VPS:
```bash
tar -xzf website-deployment.tar.gz
sudo cp -r website-deployment/src/* /var/www/your-domain.com/
```

## VPS Setup Commands

Once files are on VPS:
```bash
# 1. Install Nginx if not already installed
sudo apt update
sudo apt install nginx -y

# 2. Copy nginx config
sudo cp ~/website-deployment/deployment/nginx.conf /etc/nginx/sites-available/your-domain.com
# Edit the file to replace your-domain.com with actual domain
sudo nano /etc/nginx/sites-available/your-domain.com

# 3. Enable site
sudo ln -s /etc/nginx/sites-available/your-domain.com /etc/nginx/sites-enabled/

# 4. Test and reload
sudo nginx -t
sudo systemctl reload nginx

# 5. Set up SSL with Cloudflare (if not using Cloudflare SSL)
sudo apt install certbot python3-certbot-nginx -y
sudo certbot --nginx -d your-domain.com -d www.your-domain.com
```

## Test First!
Before deploying, test locally:
```bash
./test-locally.sh
```
Visit http://localhost:8000