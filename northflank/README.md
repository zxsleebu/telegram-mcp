# telegram-mcp на Northflank

Три файла, которые нужно добавить в форк https://github.com/chigwell/telegram-mcp:

    Dockerfile.northflank      -> в корень репозитория
    northflank/Caddyfile
    northflank/entrypoint.sh   (chmod +x)

Апстримные файлы не трогаются, поэтому rebase на новые релизы проходит чисто.

Что делает образ: один контейнер, внутри python main.py (MCP_TRANSPORT=http,
слушает 127.0.0.1:8765) и Caddy на 0.0.0.0:8080, который пускает наружу только
путь /<MCP_URL_SECRET>/mcp и /healthz.

Переменные окружения в Northflank:

    TELEGRAM_API_ID        my.telegram.org/apps
    TELEGRAM_API_HASH      my.telegram.org/apps
    TELEGRAM_SESSION_STRING  (secret) telegram-mcp-generate-session
    MCP_URL_SECRET         (secret) openssl rand -hex 24
    TELEGRAM_EXPOSED_TOOLS read-only     # опционально

URL коннектора: https://<northflank-domain>/<MCP_URL_SECRET>/mcp
