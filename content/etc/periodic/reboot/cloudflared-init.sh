#!/bin/sh
echo ""
echo "$(date) $0 $@"

delay=60
error="WRN No instances found"
logs="/root"

service cloudflared restart

while true; do
    output=$(cloudflared tunnel diag)
    if echo "$output" | grep -q "$error"; then
        echo "$(date): No instances found. Restarting cloudflared service..."
        service cloudflared restart
    else
        echo "$(date): cloudflared is running normally."
    fi

    rm "$logs"/*.zip
    sleep $delay
done
