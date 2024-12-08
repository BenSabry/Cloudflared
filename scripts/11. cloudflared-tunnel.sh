#!/bin/sh
echo ""
echo "$(date) $0 $@"

# Stop the service
service cloudflared start &
service cloudflared stop &

# Install the tunnel
cloudflared service install "$TOKEN"
