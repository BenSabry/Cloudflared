#!/bin/sh
echo ""
echo "$(date) $0 $@"

/scripts/cloudflared-setup.sh

# Install the tunnel
cloudflared service install "$TOKEN"
