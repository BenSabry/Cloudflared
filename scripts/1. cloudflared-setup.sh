#!/bin/sh
echo ""
echo "$(date) $0 $@"

# Download the latest cloudflared binary
wget https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-amd64 -O /usr/bin/cloudflared

# Make the binary executable
chmod +x /usr/bin/cloudflared

# Install the tunnel
cloudflared service install "$TOKEN"
