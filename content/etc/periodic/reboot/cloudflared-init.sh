#!/bin/sh
echo ""
echo "$(date) $0 $@"

delay=300

error="WRN No instances found"
logs="/root"
pid="/var/run/cloudflared.pid"

restartCloudflared() {
    if [ -f "$pid" ]; then
        kill $(cat "$pid")
        rm "$pid"
    fi

    service cloudflared start
    echo "cloudflared service restarted."
}

while true; do
    output=$(cloudflared tunnel diag 2>&1)
    if echo "$output" | grep -q "$error"; then
        echo "No cloudflared instances found."
        echo "Restarting cloudflared service..."
        restartCloudflared
    fi

    rm "$logs"/*.zip > /dev/null 2>&1
    sleep $delay
done
