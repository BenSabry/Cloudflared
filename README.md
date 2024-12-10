# About
This repository aims to automate the installation of Cloudflare Tunnel client (formerly Argo Tunnel) on a fresh Alpine Linux setup (LXC, VM, or bare metal), configure optimal settings for the operating system , and maintain updates with periodic jobs, all while minimizing resource usage and achieving everything with a single script.

# Setup *alpine linux only
```SHELL
wget -qO- https://raw.githubusercontent.com/BenSabry/Cloudflared/main/setup.sh | TOKEN="TOKEN" sh
```

# Tech/Tools
<b>*[Cloudflare Tunnel](https://developers.cloudflare.com/cloudflare-one/connections/connect-networks/)*</b>: provides you with a secure way to connect your resources to Cloudflare without a publicly routable IP address. With Tunnel, you do not send traffic to an external IP — instead, a lightweight daemon in your infrastructure (cloudflared) creates outbound-only connections to Cloudflare's global network. Cloudflare Tunnel can connect HTTP web servers, SSH servers, remote desktops, and other protocols safely to Cloudflare. This way, your origins can serve traffic through Cloudflare without being vulnerable to attacks that bypass Cloudflare.<br />

# Periodic Jobs
<b>Daily</b> Cloudflared Update<br />
<b>Daily</b> Rotating logs<br />
<b>Daily</b> System Upgrade<br />
