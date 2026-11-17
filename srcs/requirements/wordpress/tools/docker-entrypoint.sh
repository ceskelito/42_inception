#!/usr/bin/env bash
set -eu

: "${WP_DB_PASS_FILE:=/run/secrets/wp_db_password}"
if [ -r "$WP_DB_PASS_FILE" ]; then
    WP_DB_PASS="$(< "$WP_DB_PASS_FILE")"
fi
: "${WP_DB_PASS:?missing password}"
: "${WP_DB_USER:?missing user}"
: "${WP_DB_NAME:?missing database}"

HOST=${WP_DB_HOST:-mariadb}
PORT=${WP_DB_PORT:-3306}
TIMEOUT=${TIMEOUT:-15}

start_ts=$(date +%s)
while :; do
    if (echo > "/dev/tcp/$HOST/$PORT") >/dev/null 2>&1; then
        echo "$HOST:$PORT available after $(( $(date +%s) - start_ts ))s" >&2
        break
    fi
    if (( TIMEOUT > 0 && $(date +%s) - start_ts >= TIMEOUT )); then
        echo "timeout waiting for $HOST:$PORT" >&2
        exit 1
    fi
    sleep 1
done

exec "$@"
