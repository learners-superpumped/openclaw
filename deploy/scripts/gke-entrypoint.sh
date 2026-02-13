#!/usr/bin/env bash
set -euo pipefail

# GKE entrypoint: starts Xvfb virtual display + VNC/NoVNC,
# then execs the gateway process.
#
# Browser always runs non-headless with a virtual display.
# Access the browser screen via NoVNC (default port 6080).

export DISPLAY=:99

VNC_PORT="${OPENCLAW_BROWSER_VNC_PORT:-5900}"
NOVNC_PORT="${OPENCLAW_BROWSER_NOVNC_PORT:-6080}"

# Start Xvfb virtual display
Xvfb :99 -screen 0 1280x800x24 -ac -nolisten tcp &
sleep 0.5

# Start VNC server
x11vnc -display :99 -rfbport "$VNC_PORT" -shared -forever -nopw -localhost &

# Start NoVNC web proxy
websockify --web /usr/share/novnc/ "$NOVNC_PORT" "localhost:$VNC_PORT" &

# Execute the main gateway process
exec "$@"
