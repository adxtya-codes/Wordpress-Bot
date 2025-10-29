FROM oven/bun:1-debian

# Install Chromium and dependencies in a single layer
RUN apt-get update && apt-get install -y --no-install-recommends \
    chromium \
    chromium-sandbox \
    fonts-liberation \
    fonts-noto-color-emoji \
    libasound2 \
    libatk-bridge2.0-0 \
    libatk1.0-0 \
    libatspi2.0-0 \
    libcups2 \
    libdbus-1-3 \
    libdrm2 \
    libgbm1 \
    libgtk-3-0 \
    libnspr4 \
    libnss3 \
    libwayland-client0 \
    libxcomposite1 \
    libxdamage1 \
    libxfixes3 \
    libxkbcommon0 \
    libxrandr2 \
    libxshmfence1 \
    xdg-utils \
    ca-certificates \
    procps \
    curl \
    unzip \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Set environment variables
ENV PUPPETEER_EXECUTABLE_PATH=/usr/bin/chromium \
    PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=true \
    NODE_ENV=production \
    DEBIAN_FRONTEND=noninteractive

# Create non-root user for security
RUN groupadd -r whatsapp && useradd -r -g whatsapp -G audio,video whatsapp \
    && mkdir -p /home/whatsapp/Downloads \
    && chown -R whatsapp:whatsapp /home/whatsapp

# Set working directory
WORKDIR /app

# Copy package files first for better caching
COPY --chown=whatsapp:whatsapp package.json bun.lock* ./

# Install dependencies using Bun
RUN bun install --production --frozen-lockfile

# Copy application code
COPY --chown=whatsapp:whatsapp . .

# Switch to non-root user
USER whatsapp

# Create directories for WhatsApp session data with proper permissions
RUN mkdir -p /app/.wwebjs_auth /app/.wwebjs_cache \
    && chmod -R 755 /app/.wwebjs_auth /app/.wwebjs_cache

# Expose port
EXPOSE 3000

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=60s --retries=3 \
    CMD curl -f http://localhost:3000/health || exit 1

# Start the application with Bun
CMD ["bun", "run", "index.js"]
