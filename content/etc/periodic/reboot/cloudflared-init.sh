#!/bin/sh
echo ""
echo "$(date) $0 $@"

delay=300
error="WRN No instances found"
logs="/root"

service cloudflared restart

while true; do
    output=$(cloudflared tunnel diag > /dev/null 2>&1)
    if echo "$output" | grep -q "$error"; then
        echo "No instances found. Restarting cloudflared service..."
        service cloudflared restart
    fi

    rm "$logs"/*.zip > /dev/null 2>&1
    sleep $delay
done
