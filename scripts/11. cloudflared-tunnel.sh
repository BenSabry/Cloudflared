#!/bin/sh
echo ""
echo "$(date) $0 $@"

# Install the tunnel
cloudflared service install "$TOKEN"
