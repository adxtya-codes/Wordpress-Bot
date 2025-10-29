# Coolify Deployment Setup Guide

## ⚠️ Important: Environment Variables

**DO NOT use `.env` file on Coolify!** The `.env` file is only for local development.

On Coolify, environment variables must be set in the dashboard.

## Step-by-Step Coolify Setup

### 1. Create New Application

1. Go to your Coolify dashboard
2. Click **"New Resource"** → **"Application"**
3. Select **"Public Repository"** or connect your GitHub
4. Enter repository URL: `https://github.com/adxtya-codes/Wordpress-Bot.git`
5. Select branch: `main`

### 2. Configure Build Method

Choose **ONE** of these options:

#### Option A: Using Dockerfile (Recommended)
- Build Pack: **Dockerfile**
- Dockerfile Location: `./Dockerfile`

#### Option B: Using Nixpacks
- Build Pack: **Nixpacks**
- Nixpacks will use `nixpacks.toml` automatically

### 3. Set Environment Variables

In the **Environment Variables** section, add:

```
RESEND_API_KEY=re_6HYN9abN_ALH6shJrunYKuSj3mdhuWCtb
CLIENT_EMAIL=abonnementnova.store@gmail.com
PUPPETEER_EXECUTABLE_PATH=/usr/bin/chromium
NODE_ENV=production
```

**Important:** 
- Click **"Add"** after each variable
- Make sure there are NO spaces around the `=` sign
- Save changes

### 4. Configure Persistent Storage

Add **two volumes** for WhatsApp session persistence:

**Volume 1:**
- Name: `whatsapp-session`
- Mount Path: `/app/.wwebjs_auth`

**Volume 2:**
- Name: `whatsapp-cache`
- Mount Path: `/app/.wwebjs_cache`

### 5. Port Configuration

- **Port:** `3000`
- **Protocol:** HTTP

### 6. Resource Limits (Recommended)

- **Memory:** At least `1GB` (1024 MB)
- **CPU:** At least `1` core

### 7. Deploy

1. Click **"Deploy"**
2. Wait for build to complete (may take 5-10 minutes on first deploy)
3. Check logs for deployment status

### 8. Scan QR Code

1. Go to **"Logs"** tab
2. Look for QR code in ASCII art
3. Open WhatsApp on your phone
4. Go to **Settings** → **Linked Devices** → **Link a Device**
5. Scan the QR code from the logs

### 9. Verify Deployment

Check logs for:
```
WhatsApp authenticated successfully
WhatsApp bot is ready!
```

## Troubleshooting

### Issue: "injecting env (0) from .env"

**Solution:** You're seeing this because dotenv is trying to read a `.env` file, but on Coolify you should use environment variables from the dashboard instead. This warning is harmless if you've set variables in Coolify dashboard.

### Issue: "Execution context was destroyed"

**Possible causes:**
1. Chromium not installed (check build logs)
2. Insufficient memory (increase to 1GB+)
3. Wrong executable path

**Solution:**
- Ensure `PUPPETEER_EXECUTABLE_PATH=/usr/bin/chromium` is set
- Check build logs for Chromium installation
- Increase memory allocation

### Issue: Session lost after restart

**Solution:**
- Ensure volumes are properly mounted
- Check volume paths: `/app/.wwebjs_auth` and `/app/.wwebjs_cache`

### Issue: Cannot access webhook

**Solution:**
- Ensure port 3000 is exposed
- Check domain/URL configuration in Coolify
- Webhook endpoint: `https://your-domain.com/webhook`

## Checking Logs

### Real-time logs:
```bash
# In Coolify dashboard, go to Logs tab
# Or use Coolify CLI:
coolify logs -f <app-name>
```

### Check if Chromium is installed:
After deployment, you can check via Coolify console:
```bash
which chromium
# Should output: /usr/bin/chromium

chromium --version
# Should output version number
```

## Environment Variables Reference

| Variable | Value | Required |
|----------|-------|----------|
| `RESEND_API_KEY` | Your Resend API key | Yes |
| `CLIENT_EMAIL` | Your email address | Yes |
| `PUPPETEER_EXECUTABLE_PATH` | `/usr/bin/chromium` | Yes |
| `NODE_ENV` | `production` | Recommended |

## Webhook URL

After deployment, your webhook will be available at:
```
https://your-coolify-domain.com/webhook
```

Use this URL in your WordPress form configuration.

## Important Notes

- **First deployment takes longer** due to Chromium installation
- **QR code expires after 60 seconds** - scan quickly
- **Session persists** across restarts (thanks to volumes)
- **Memory usage:** Expect 300-500MB RAM usage
- **Restart policy:** Container auto-restarts on failure

## Support

If you encounter issues:
1. Check Coolify build logs
2. Check application logs
3. Verify all environment variables are set
4. Ensure volumes are mounted correctly
5. Check memory/CPU allocation
