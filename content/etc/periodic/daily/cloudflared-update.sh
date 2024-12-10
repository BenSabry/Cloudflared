#!/bin/sh
echo ""
echo "$(date) $0 $@"

update() {
    service cloudflared stop
    /scripts/cloudflared-setup.sh
    service cloudflared start
}


/scripts/github-updater.sh "cloudflare" "cloudflared" update
