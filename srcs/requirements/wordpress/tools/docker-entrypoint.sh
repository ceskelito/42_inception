#!/bin/bash

set -e

: "${WP_DB_PASS_FILE:=/run/secrets/wp_db_password}"

[ -r "$WP_DB_PASS_FILE" ] && WP_DB_PASS="$(< "$WP_DB_PASS_FILE")"

: "${WP_DB_PASS:?missing password}"
: "${WP_DB_USER:?missing user}"
: "${WP_DB_NAME:?missing database}"

exec $@
