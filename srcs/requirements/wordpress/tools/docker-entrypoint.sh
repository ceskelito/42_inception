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

# place_envs()
# {
# 	local file=$1
# 
# 	sed -i "s|.*DB_NAME.*|define( 'DB_NAME', '${WP_DB_NAME}' )|" ${file}
# 	sed -i "s|.*DB_USER.*|define( 'DB_USER', '${WP_DB_USER}' )|" ${file}
# 	sed -i "s|.*DB_PASSWORD.*|define( 'DB_PASSWORD', '${WP_DB_PASS}' )|" ${file}
# 	sed -i "s|.*DB_HOST.*|define( 'DB_HOST', '${WP_DB_HOST}' )|" ${file}
# }
  
main()
{
  check_envs

	local source_file='/var/www/html/wordpress/wp-config-sample.php'
	
	if [ ! -f $source_file ]; then
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
