# Website Deployment

This is a modern "Under Construction" page with video background support.

## Project Structure
```
website-deployment/
├── src/                    # Source files
│   ├── index.html         # Main HTML page
│   ├── assets/
│   │   ├── css/
│   │   │   └── styles.css # Styling with animations
│   │   └── videos/
│   │       └── construction.mp4 # Your video file (add this)
├── deployment/            # Deployment scripts
│   ├── deploy.sh         # Deployment script
│   └── nginx.conf        # Nginx configuration
└── README.md             # This file
```

## Local Testing
```bash
cd src
python3 -m http.server 8000
# Visit http://localhost:8000
```

## Video Requirements
- Place your looping video in `src/assets/videos/construction.mp4`
- Recommended format: MP4 (H.264) for best compatibility
- Keep file size under 10MB for fast loading
- Consider creating a WebM version for better browser support

## VPS Deployment

### 1. Initial VPS Setup
```bash
# Update system
sudo apt update && sudo apt upgrade -y

# Install Nginx
sudo apt install nginx -y

# Install certbot for SSL
sudo apt install certbot python3-certbot-nginx -y
```

### 2. Configure Nginx
Copy the nginx.conf from deployment/ to your VPS and update:
```bash
sudo cp nginx.conf /etc/nginx/sites-available/your-domain.com
sudo ln -s /etc/nginx/sites-available/your-domain.com /etc/nginx/sites-enabled/
sudo nginx -t
sudo systemctl reload nginx
```

### 3. Deploy Files
Use the deployment script:
```bash
./deployment/deploy.sh
```

### 4. Cloudflare Setup
1. Add A record pointing to your VPS IP
2. Enable proxy (orange cloud)
3. SSL/TLS → Full (strict)
4. Speed → Optimization → Enable Auto Minify
5. Speed → Optimization → Enable Brotli
6. Caching → Configuration → Browser Cache TTL: 4 hours

### 5. Security Headers (already in nginx.conf)
- X-Frame-Options: SAMEORIGIN
- X-Content-Type-Options: nosniff
- X-XSS-Protection: 1; mode=block
- Referrer-Policy: strict-origin-when-cross-origin

## Monitoring
- Check Nginx logs: `sudo tail -f /var/log/nginx/access.log`
- Monitor errors: `sudo tail -f /var/log/nginx/error.log`

## Future Enhancements
- Add email collection form
- Integrate countdown timer
- Add social media links
- Implement progress percentage
- Add particle effects