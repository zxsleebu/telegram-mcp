# telegram-mcp в Obot

Образ для containerized-рантайма Obot: `ghcr.io/zxsleebu/telegram-mcp`.
Собирается workflow `obot-image.yml` под linux/arm64 и linux/amd64 на каждый
push в main, который меняет код или эти файлы.

Внутри то же, что и в образе для Northflank (python:3.13-slim + cryptg), только
Caddy не требует секретного пути: авторизацию делает шлюз Obot. Caddy подменяет
Host, потому что Obot ходит в контейнер по IP, а telegram-mcp принимает только
localhost.

Карточка сервера лежит в приватном каталоге `zxsleebu/mcp-catalog`
(`servers/telegram.yaml`). Переменные окружения задаются в Obot при подключении:
`TELEGRAM_API_ID`, `TELEGRAM_API_HASH`, `TELEGRAM_SESSION_STRING`.

Нельзя одновременно гонять одну и ту же сессию здесь и на Northflank: Telegram
может отозвать ключ (AUTH_KEY_DUPLICATED).
