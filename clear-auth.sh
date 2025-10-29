#!/bin/bash

echo "🧹 Clearing WhatsApp authentication cache..."

# Remove the .wwebjs_auth directory if it exists
if [ -d ".wwebjs_auth" ]; then
    rm -rf .wwebjs_auth
    echo "✅ Auth cache cleared successfully!"
    echo "📱 Next startup will require QR code scan"
else
    echo "ℹ️  No auth cache found"
fi

echo "Done!"
