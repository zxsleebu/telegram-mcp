#!/bin/sh
set -eu

python /app/main.py &
MCP_PID=$!

# If telegram-mcp dies, Caddy would keep answering 502. Stop the container so
# Obot sees the failure and restarts it.
(
	while kill -0 "$MCP_PID" 2>/dev/null; do sleep 5; done
	echo "telegram-mcp exited, stopping container" >&2
	kill -TERM 1 2>/dev/null || true
) &

exec caddy run --config /etc/caddy/Caddyfile --adapter caddyfile
