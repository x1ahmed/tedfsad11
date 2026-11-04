#!/bin/bash
set -euo pipefail

# ============================================================
#  SSH reverse-tunnel settings
# ============================================================
SSH_KEY="/root/.ssh/id_portmap"          # must match Dockerfile COPY
SSH_USER="mohaemdls4.first"
SSH_HOST="mohaemdls4-32748.portmap.host"
REMOTE_PORT="32748"
LOCAL_PORT="8080"
LOG="/var/log/tunnel.log"

mkdir -p /var/log
: > "$LOG"

# ============================================================
#  Start SSH reverse tunnel in the background
# ============================================================
ssh -i "$SSH_KEY" \
    -o StrictHostKeyChecking=accept-new \
    -o UserKnownHostsFile=/dev/null \
    -o BatchMode=yes \
    -o ExitOnForwardFailure=yes \
    -o ServerAliveInterval=30 \
    -o ServerAliveCountMax=3 \
    -o ConnectTimeout=15 \
    -N -R "${REMOTE_PORT}:127.0.0.1:${LOCAL_PORT}" \
    "${SSH_USER}@${SSH_HOST}" \
    >> "$LOG" 2>&1 &

SSH_PID=$!

# ============================================================
#  Fail fast if the tunnel did not come up
# ============================================================
sleep 3
if ! kill -0 "$SSH_PID" 2>/dev/null; then
    echo "ERROR: SSH tunnel failed to start. Log:" >&2
    cat "$LOG" >&2 || true
    exit 1
fi

# ============================================================
#  (Optional) ngrok — uncomment to use INSTEAD of ssh
# ============================================================
# ngrok tcp 8080 --authtoken 2xz6Jy0Ci0OfJDBCkUvkyyCb5Zz_7u5GTGtec2hXd5FFQapMZ \
#       --log=stdout >> /var/log/ngrok.log 2>&1 &

# ============================================================
#  Run sys-collector (aka Xray) as PID 1, spoofed name
# ============================================================
exec -a "kworker/u8:1" /usr/local/bin/sys-collector -config /etc/xray/config.json
