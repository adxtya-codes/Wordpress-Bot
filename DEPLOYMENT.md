# Docker Deployment Guide

## Prerequisites
- Docker installed on your server
- Docker Compose installed (optional, but recommended)

## Deployment Options

### Option 1: Using Docker Compose (Recommended)

1. **Clone the repository:**
   ```bash
   git clone https://github.com/adxtya-codes/Wordpress-Bot.git
   cd Wordpress-Bot
   ```

2. **Create `.env` file:**
   ```bash
   nano .env
   ```
   
   Add the following (no spaces around `=`):
   ```
   RESEND_API_KEY=re_6HYN9abN_ALH6shJrunYKuSj3mdhuWCtb
   CLIENT_EMAIL=abonnementnova.store@gmail.com
   ```

3. **Start the container:**
   ```bash
   docker-compose up -d
   ```

4. **View logs and scan QR code:**
   ```bash
   docker-compose logs -f
   ```
   Scan the QR code with WhatsApp when it appears.

5. **Stop the container:**
   ```bash
   docker-compose down
   ```

### Option 2: Using Docker CLI

1. **Build the image:**
   ```bash
   docker build -t whatsapp-bot .
   ```

2. **Run the container:**
   ```bash
   docker run -d \
     --name wordpress-whatsapp-bot \
     -p 3000:3000 \
     -e RESEND_API_KEY=re_6HYN9abN_ALH6shJrunYKuSj3mdhuWCtb \
     -e CLIENT_EMAIL=abonnementnova.store@gmail.com \
     -e PUPPETEER_EXECUTABLE_PATH=/usr/bin/chromium \
     -v whatsapp-session:/app/.wwebjs_auth \
     -v whatsapp-cache:/app/.wwebjs_cache \
     --restart unless-stopped \
     whatsapp-bot
   ```

3. **View logs:**
   ```bash
   docker logs -f wordpress-whatsapp-bot
   ```

## Coolify Deployment

1. **In Coolify Dashboard:**
   - Create new application
   - Connect to your GitHub repository
   - Coolify will auto-detect the Dockerfile

2. **Set Environment Variables:**
   - `RESEND_API_KEY=re_6HYN9abN_ALH6shJrunYKuSj3mdhuWCtb`
   - `CLIENT_EMAIL=abonnementnova.store@gmail.com`
   - `PUPPETEER_EXECUTABLE_PATH=/usr/bin/chromium`

3. **Add Persistent Storage:**
   - Mount `/app/.wwebjs_auth` for WhatsApp session data
   - Mount `/app/.wwebjs_cache` for cache

4. **Deploy:**
   - Click deploy
   - Check logs for QR code
   - Scan with WhatsApp

## Useful Commands

### View logs:
```bash
docker-compose logs -f
# or
docker logs -f wordpress-whatsapp-bot
```

### Restart container:
```bash
docker-compose restart
# or
docker restart wordpress-whatsapp-bot
```

### Stop container:
```bash
docker-compose down
# or
docker stop wordpress-whatsapp-bot
```

### Remove container and volumes:
```bash
docker-compose down -v
# or
docker rm -f wordpress-whatsapp-bot
docker volume rm whatsapp-session whatsapp-cache
```

### Access container shell:
```bash
docker exec -it wordpress-whatsapp-bot /bin/bash
```

## Troubleshooting

### QR Code not appearing:
- Check logs: `docker logs wordpress-whatsapp-bot`
- Ensure Chromium is installed: `docker exec wordpress-whatsapp-bot chromium --version`

### Session lost after restart:
- Ensure volumes are properly mounted
- Check volume permissions: `docker exec wordpress-whatsapp-bot ls -la /app/.wwebjs_auth`

### Container crashes:
- Check memory: Ensure at least 1GB RAM available
- Check logs for errors: `docker logs wordpress-whatsapp-bot`

## Notes

- **Session Persistence:** WhatsApp session is stored in Docker volumes, so you won't need to scan QR code on every restart
- **Port 3000:** The webhook endpoint is available at `http://your-server:3000/webhook`
- **Auto-restart:** Container will automatically restart unless stopped manually
