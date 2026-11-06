#!/bin/bash
set -e

: "${WP_DB_PASS_FILE:=/run/secrets/wp_db_password}"
[ -r "$WP_DB_PASS_FILE" ] && WP_DB_PASSWORD="$(< "$WP_DB_PASS_FILE")"

: "${WP_DB_PASSWORD:?missing password}"
: "${WP_DB_USER:?missing user}"
: "${WP_DB_NAME:?missing database}"

mkdir -p /run/mysqld
chown mysql:mysql /run/mysqld

service mariadb start

mariadb -e "CREATE DATABASE IF NOT EXISTS \`${WP_DB_NAME}\`;"
mariadb -e "CREATE USER IF NOT EXISTS '${WP_DB_USER}'@'%' IDENTIFIED BY '${WP_DB_PASSWORD}';"
mariadb -e "GRANT ALL ON \`${WP_DB_NAME}\`.* TO '${WP_DB_USER}'@'%';"
mariadb -e "FLUSH PRIVILEGES;"

mariadb-admin shutdown

unset WP_DB_PASSWORD

exec $@ #mariadbd --user=mysql
