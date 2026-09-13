#!/bin/sh
set -eu

: "${MCP_URL_SECRET:?MCP_URL_SECRET must be set (openssl rand -hex 24)}"

python /app/main.py &
MCP_PID=$!

# Caddy would keep answering 502 if the MCP process died, and Northflank's
# health check would stay green. Take the container down instead so it restarts.
(
	while kill -0 "$MCP_PID" 2>/dev/null; do sleep 5; done
	echo "telegram-mcp exited, stopping container" >&2
	kill -TERM 1 2>/dev/null || true
) &

exec caddy run --config /etc/caddy/Caddyfile --adapter caddyfile
