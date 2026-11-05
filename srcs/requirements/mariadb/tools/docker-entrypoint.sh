#!/bin/bash
set -e

: "${INC_MYSQL_PASS_FILE:=/run/secrets/mysql_pass}"
[ -r "$INC_MYSQL_PASS_FILE" ] && INC_MYSQL_PASS="$(< "$INC_MYSQL_PASS_FILE")"

: "${INC_MYSQL_PASS:?missing password}"
: "${INC_MYSQL_USER:?missing user}"
: "${INC_MYSQL_DB:?missing database}"

mkdir -p /run/mysqld
chown mysql:mysql /run/mysqld

service mariadb start

mariadb -e "CREATE DATABASE IF NOT EXISTS \`${INC_MYSQL_DB}\`;"
mariadb -e "CREATE USER IF NOT EXISTS '${INC_MYSQL_USER}'@'%' IDENTIFIED BY '${INC_MYSQL_PASS}';"
mariadb -e "GRANT ALL ON \`${INC_MYSQL_DB}\`.* TO '${INC_MYSQL_USER}'@'%';"
mariadb -e "FLUSH PRIVILEGES;"

mariadb-admin shutdown

unset INC_MYSQL_PASS

exec $@ #mariadbd --user=mysql
