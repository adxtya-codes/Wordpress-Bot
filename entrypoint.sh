#!/bin/bash
set -e

echo "🔧 Ensuring correct permissions for WhatsApp session directories..."

# Remove old directories if they exist and recreate them
if [ -d "/app/.wwebjs_auth" ]; then
    echo "📁 Existing .wwebjs_auth directory found, fixing permissions..."
    chmod -R 777 /app/.wwebjs_auth 2>/dev/null || rm -rf /app/.wwebjs_auth
fi

if [ -d "/app/.wwebjs_cache" ]; then
    echo "📁 Existing .wwebjs_cache directory found, fixing permissions..."
    chmod -R 777 /app/.wwebjs_cache 2>/dev/null || rm -rf /app/.wwebjs_cache
fi

# Ensure directories exist with full permissions
mkdir -p /app/.wwebjs_auth /app/.wwebjs_cache
chmod -R 777 /app/.wwebjs_auth /app/.wwebjs_cache

echo "✅ Permission check complete"
echo "🚀 Starting application..."

# Execute the main command
exec "$@"
