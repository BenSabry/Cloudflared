#!/bin/sh
echo ""
echo "$(date) $0 $@"

cloudflared update
