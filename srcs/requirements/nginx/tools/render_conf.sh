#!/usr/bin/env bash
set -euo pipefail
umask 022   # rendered config is not secret: it must stay readable by the container

# Directory where this script lives, independent of the caller's cwd
SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"

# Defaults derived from the script location, overridable from the outside
ENV_FILE="${ENV_FILE:-${SCRIPT_DIR}/../../../.env}"
TEMPLATE="${TEMPLATE:-${SCRIPT_DIR}/../conf/default.conf.template}"
OUT_DIR="${OUT_DIR:-${SCRIPT_DIR}/../rendered}"
OUT_FILE="${OUT_FILE:-default.conf}"

# Variables to substitute. Anything else (e.g. nginx's $uri, $host) is left untouched.
VARS=(BASE_DOMAIN)

die() { echo "error: $*" >&2; exit 1; }

command -v envsubst >/dev/null \
    || die "envsubst not found (apt install gettext-base)"

[[ -f "$ENV_FILE" ]] || die ".env file not found: $ENV_FILE"
[[ -f "$TEMPLATE" ]] || die "template not found: $TEMPLATE"

# Load the .env and export its variables so envsubst can see them
set -a
# shellcheck source=/dev/null
source "$ENV_FILE"
set +a

# Fallback and validation: every listed variable must be set and non-empty
shell_format=""
for var in "${VARS[@]}"; do
    val="${!var:-}"
    val="${val%$'\r'}"          # strip a stray CR from CRLF line endings
    [[ -n "$val" ]] || die "$var is not defined (or empty) in $ENV_FILE"
    export "$var=$val"
    shell_format+="\${${var}} "
done

# The domain ends up inside nginx directives: reject anything unexpected
case "${BASE_DOMAIN}" in
    ""|*[!A-Za-z0-9.-]*|.*|*.|-*)
        die "invalid BASE_DOMAIN: '${BASE_DOMAIN}'" ;;
esac

# Every ${PLACEHOLDER} in the template must be in VARS, otherwise it would
# reach nginx unexpanded
while IFS= read -r placeholder; do
    name="${placeholder#\$\{}"
    name="${name%\}}"
    [[ " ${VARS[*]} " == *" ${name} "* ]] \
        || die "template uses \${${name}} but it is not in VARS (edit $(basename "$0"))"
done < <(grep -oE '\$\{[A-Za-z_][A-Za-z0-9_]*\}' "$TEMPLATE" | sort -u || true)

render_conf()
{
    local out="${OUT_DIR}/${OUT_FILE}"
    local tmp

    mkdir -p "$OUT_DIR"

    # Render to a temp file in the same directory, then move it into place:
    # a failed render never leaves a half-written config behind
    tmp="$(mktemp "${OUT_DIR}/.${OUT_FILE}.XXXXXX")"
    trap 'rm -f "$tmp"' EXIT

    envsubst "$shell_format" < "$TEMPLATE" > "$tmp"

    [[ -s "$tmp" ]] || die "rendered config is empty"

    chmod 644 "$tmp"
    mv -f "$tmp" "$out"
    trap - EXIT

    echo "rendered: $out (from $TEMPLATE)"
}

render_conf
