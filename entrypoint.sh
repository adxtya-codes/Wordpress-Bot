#!/bin/bash
set -e

echo "🔧 Ensuring correct permissions for WhatsApp session directories..."

# Ensure directories exist with correct permissions
mkdir -p /app/.wwebjs_auth /app/.wwebjs_cache

# Check if we have write permissions
if [ ! -w /app/.wwebjs_auth ]; then
    echo "⚠️  Warning: No write permission for /app/.wwebjs_auth"
    echo "This might cause issues. Attempting to fix..."
    # If running as root (e.g., in development), fix permissions
    if [ "$(id -u)" = "0" ]; then
        chown -R whatsapp:whatsapp /app/.wwebjs_auth /app/.wwebjs_cache
        chmod -R 775 /app/.wwebjs_auth /app/.wwebjs_cache
        echo "✅ Permissions fixed"
    fi
fi

echo "✅ Permission check complete"
echo "🚀 Starting application..."

# Execute the main command
exec "$@"
