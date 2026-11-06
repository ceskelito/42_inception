#!/bin/bash

set -e

check_envs()
{
  : "${WP_DB_PASS_FILE:=/run/secrets/mysql_pass}"
  [ -r "$WP_DB_PASS_FILE" ] && WP_DB_PASSWORD="$(< "$WP_DB_PASS_FILE")"

  : "${WP_DB_PASSWORD:?missing password}"
  : "${WP_DB_USER:?missing user}"
  : "${WP_DB_NAME:?missing database}"
}

place_envs()
{
	local file=$1

	sed -i "s|.*DB_NAME.*|define( 'DB_NAME', '${WP_DB_NAME}' )|" ${file}
	sed -i "s|.*DB_USER.*|define( 'DB_USER', '${WP_DB_USER}' )|" ${file}
	sed -i "s|.*DB_PASSWORD.*|define( 'DB_PASSWORD', '${WP_DB_PASSWORD}' )|" ${file}
	sed -i "s|.*DB_HOST.*|define( 'DB_HOST', '${WP_DB_HOST}' )|" ${file}
}

main()
{
  check_envs

	local source_file='/var/www/html/wordpress/wp-config-sample.php'
	local target_file='/var/www/html/wordpress/wp-config.php'

	if [ ! -f $target_file ]; then
		
		cp $source_file $target_file

		place_envs $target_file

		chown www-data:www-data $target_file

  else

    echo "$target_file already present"

  fi
}

exec php-fpm
