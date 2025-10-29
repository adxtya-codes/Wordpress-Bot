#!/bin/bash
set -e

echo "🔧 Ensuring correct permissions for WhatsApp session directories..."

# Ensure directories exist
mkdir -p /app/.wwebjs_auth /app/.wwebjs_cache

# Try to fix permissions on existing directories (don't remove them!)
if [ -d "/app/.wwebjs_auth" ]; then
    echo "📁 Setting permissions on .wwebjs_auth..."
    chmod -R 777 /app/.wwebjs_auth 2>/dev/null || true

    # Remove Chromium lock files to prevent "profile in use" errors
    echo "🔓 Cleaning up Chromium lock files..."
    find /app/.wwebjs_auth -name "SingletonLock" -type f -delete 2>/dev/null || true
    find /app/.wwebjs_auth -name "SingletonSocket" -type s -delete 2>/dev/null || true
    find /app/.wwebjs_auth -name "SingletonCookie" -type f -delete 2>/dev/null || true
    echo "✅ Lock files cleaned"
fi

if [ -d "/app/.wwebjs_cache" ]; then
    echo "📁 Setting permissions on .wwebjs_cache..."
    chmod -R 777 /app/.wwebjs_cache 2>/dev/null || true
fi

echo "✅ Permission check complete"
echo "🚀 Starting application..."

# Execute the main command
exec "$@"
