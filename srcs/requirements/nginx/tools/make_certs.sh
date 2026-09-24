#!/usr/bin/env bash

set -euo pipefail
umask 077   # created files are born without group/other permissions

# Obtain absolute path of working directory
SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"

# Defaults derived from the script, overridable from outside
ENV_FILE="${ENV_FILE:-${SCRIPT_DIR}/../../../.env}"
CERTS_DIR="${CERTS_DIR:-${SCRIPT_DIR}/../certs}"

die() { echo "error: $*" >&2; exit 1; }

[[ -f "$ENV_FILE" ]] || die ".env file not found: $ENV_FILE"

# shellcheck source=/dev/null
source "$ENV_FILE"

# Variable fallbacks and validation
: "${BASE_DOMAIN:?BASE_DOMAIN not defined in $ENV_FILE}"

[[ "$BASE_DOMAIN" =~ ^[A-Za-z0-9]([A-Za-z0-9.-]*[A-Za-z0-9])?$ ]] \
    || die "invalid BASE_DOMAIN: '$BASE_DOMAIN'"

# USER may be missing (cron, containers, minimal environments)
CERT_USER="${USER:-$(id -un)}"
CERT_USER="${CERT_USER//[^A-Za-z0-9._-]/_}"   # no characters that break -subj

make_certs()
{
    local domain="$BASE_DOMAIN"
    local key="${CERTS_DIR}/${domain}.key"
    local crt="${CERTS_DIR}/${domain}.crt"

    if [[ -f "$key" && -f "$crt" && "${FORCE:-0}" != "1" ]]; then
        echo "certificates already present in $CERTS_DIR (use FORCE=1 to regenerate)"
        return 0
    fi

    mkdir -p "$CERTS_DIR"

    openssl req -x509 -newkey rsa:2048 -nodes -days 365 \
        -keyout "$key" \
        -out "$crt" \
        -addext "subjectAltName=DNS:${domain},DNS:www.${domain}" \
        -addext "basicConstraints=critical,CA:FALSE" \
        -addext "extendedKeyUsage=serverAuth" \
        -subj "/C=IT/ST=Rome/L=Rome/O=42Roma/OU=${CERT_USER}/CN=${domain}"

    chmod 600 "$key"
    chmod 644 "$crt"
    echo "generated: $crt, $key"
}

make_certs
