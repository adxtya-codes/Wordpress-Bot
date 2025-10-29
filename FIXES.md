# Recent Fixes Applied

## Issue 1: Bot Stuck on Server with Cached Auth ✅

**Problem**: WhatsApp client getting stuck during initialization with cached auth on the server.

**Solution**:
- Added 2-minute initialization timeout that auto-restarts the process
- Enhanced logging for debugging authentication state
- Improved health endpoint to detect stuck initialization
- Better event handlers for `authenticated`, `ready`, and `auth_failure`

**Files Modified**:
- [index.js](index.js): Lines 61-238 - Added timeout mechanism and better event handlers

---

## Issue 2: Permission Denied Error ✅

**Problem**:
```
ERROR: Failed to create /app/.wwebjs_auth/session/SingletonLock: Permission denied (13)
```

**Root Cause**: The WhatsApp session directories didn't have proper write permissions for the `whatsapp` user.

**Solution**:
1. **Dockerfile Changes**:
   - Create directories BEFORE switching to non-root user
   - Set proper ownership with `chown -R whatsapp:whatsapp`
   - Set write permissions with `chmod -R 775`

2. **Entrypoint Script**: Added [entrypoint.sh](entrypoint.sh) that:
   - Ensures directories exist at runtime
   - Checks write permissions
   - Fixes permissions if needed (for volume mounts)
   - Provides helpful error messages

**Files Modified**:
- [Dockerfile](Dockerfile): Lines 58-64, 77-78
- [entrypoint.sh](entrypoint.sh): New file

---

## Upgrade: Migrated to Bun Runtime ⚡

**Changes**:
- Base image: `node:18-bullseye-slim` → `oven/bun:1-debian`
- Package manager: `npm` → `bun`
- Install command: `npm ci` → `bun install --production --frozen-lockfile`
- Runtime: `node index.js` → `bun run index.js`
- Health check: Node.js script → `curl` command

**Benefits**:
- 🚀 Faster startup time
- 💾 Lower memory usage
- 📦 Faster package installation
- ✅ Full Node.js API compatibility

**Files Modified**:
- [Dockerfile](Dockerfile): Complete rewrite for Bun

---

## How to Deploy

### 1. Clear Old Auth Cache (if needed)
```bash
# On server via Docker
docker exec -it <container-id> rm -rf /app/.wwebjs_auth
docker restart <container-id>

# Or use the script locally
./clear-auth.sh
```

### 2. Rebuild and Deploy
```bash
# Build the new image
docker build -t whatsapp-bot .

# Run it
docker run -d \
  -p 3000:3000 \
  -e RESEND_API_KEY=your_key \
  -e CLIENT_EMAIL=your_email \
  -e PUPPETEER_EXECUTABLE_PATH=/usr/bin/chromium \
  --name whatsapp-bot \
  whatsapp-bot
```

### 3. Monitor Logs
```bash
docker logs -f whatsapp-bot
```

Look for:
- ✅ `WhatsApp bot is ready!` - Success
- 📱 `QR Code received` - Scan to authenticate
- ⏰ `initialization timeout` - Needs restart/auth clear

### 4. Check Health
```bash
curl http://localhost:3000/health
```

Expected response when ready:
```json
{
  "status": "healthy",
  "whatsappReady": true,
  "initializationComplete": true,
  "uptimeSeconds": 45,
  "timestamp": "2025-10-30T..."
}
```

---

## Troubleshooting

### Still Getting Permission Errors?
1. Check if volumes are mounted with wrong permissions
2. Ensure Docker has permission to create files in the mount path
3. Try running without volume mounts first

### Bot Still Timing Out?
1. Clear auth cache: `rm -rf .wwebjs_auth`
2. Restart container
3. Scan QR code immediately when prompted
4. Check network connectivity to WhatsApp servers

### Can't See QR Code?
- The QR code is printed in the Docker logs
- Use `docker logs <container-id>` to see it
- Make sure your terminal supports Unicode/QR display

---

## Files Created/Modified

### New Files:
- ✨ [entrypoint.sh](entrypoint.sh) - Runtime permission check
- ✨ [clear-auth.sh](clear-auth.sh) - Auth cache cleanup script
- ✨ [DEPLOYMENT_NOTES.md](DEPLOYMENT_NOTES.md) - Deployment guide
- ✨ [FIXES.md](FIXES.md) - This file

### Modified Files:
- 🔧 [index.js](index.js) - Added timeout and better error handling
- 🔧 [Dockerfile](Dockerfile) - Migrated to Bun, fixed permissions
- 🔧 [.dockerignore](.dockerignore) - Added new files

---

## Next Steps

1. **Test Locally**: Build and run the new Docker image locally
2. **Deploy to Server**: Push to your server/Coolify
3. **Monitor**: Watch logs for successful initialization
4. **Scan QR**: Have phone ready to scan QR code if needed

If issues persist, check the logs and refer to [DEPLOYMENT_NOTES.md](DEPLOYMENT_NOTES.md) for detailed troubleshooting.
