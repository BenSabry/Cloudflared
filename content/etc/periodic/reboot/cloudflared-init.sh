#!/bin/sh
echo ""
echo "$(date) $0 $@"

service cloudflared stop
service cloudflared start
