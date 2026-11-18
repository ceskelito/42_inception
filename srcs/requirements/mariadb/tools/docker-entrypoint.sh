#!/usr/bin/env bash

set -eu

: "${WP_DB_PASS_FILE:=/run/secrets/wp_db_password}"
[ -r "$WP_DB_PASS_FILE" ] && WP_DB_PASSWORD="$(< "$WP_DB_PASS_FILE")"

: "${WP_DB_PASSWORD:?missing password}"
: "${WP_DB_USER:?missing user}"
: "${WP_DB_NAME:?missing database}"

: "${DATADIR:=/var/lib/mysql}"

##
# If datadir doesn't exists, run a temporary DB server and initialize mariadb
##
if [ ! -d $DATADIR/mysql ]; then

	echo "Initializing datadir..."	

	mariadb-install-db \
		--user=mysql \
		--datadir="$DATADIR" \
		--skip-test-db \
		--default-time-zone=SYSTEM \
		--skip-log-bin \
		--expire-logs-days=0 \
		&>/dev/null

# Temporary startup, only Unix Socket
		mariadbd --user=mysql --skip-networking &
		pid=$!

# Wait until the server is ready
	for i in {30..0}; do
		mariadb-admin ping --silent 2>/dev/null && break
		sleep 1
	done

	[ "$i" = 0 ] && { echo "MariaDB failed to start" >&2; exit 1; }

# Create Wordpress Database
	mariadb <<-EOSQL
		CREATE DATABASE IF NOT EXISTS \`${WP_DB_NAME}\`;
		CREATE USER IF NOT EXISTS '${WP_DB_USER}'@'%' IDENTIFIED BY '${WP_DB_PASSWORD}';
		GRANT ALL ON \`${WP_DB_NAME}\`.* TO '${WP_DB_USER}'@'%';
		FLUSH PRIVILEGES;
	EOSQL

# Shutting down temporary server
		mariadb-admin shutdown
		wait "$pid"
fi

unset WP_DB_PASSWORD

exec $@
