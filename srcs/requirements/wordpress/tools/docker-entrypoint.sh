#!/bin/bash

set -e

check_envs()
{
	: "${WP_DB_PASS_FILE:=/run/secrets/wp_db_password}"
  [ -r "$WP_DB_PASS_FILE" ] && WP_DB_PASS="$(< "$WP_DB_PASS_FILE")"

  : "${WP_DB_PASS:?missing password}"
  : "${WP_DB_USER:?missing user}"
  : "${WP_DB_NAME:?missing database}"
}

main()
{
  check_envs

	local target_file='/var/www/html/wordpress/wp-config.php'
	
	if [ ! -f $target_file ]; then
		wp config create --allow-root \
		--dbname="$WP_DB_NAME" \
		--dbuser="$WP_DB_USER" \
		--dbpass="$WP_DB_PASS" \
		--dbhost="$WP_DB_HOST"
		echo "wp-config.php generated"
	fi

}

main

exec $@
