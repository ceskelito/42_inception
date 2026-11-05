#!/bin/bash

set -e

exit # the script is only for example purposes - need to be modified

cd /var/www/html

if [ ! -f wp-config.php ]; then
    echo "Genero wp-config.php..."
    cp wp-config-sample.php wp-config.php

    sed -i "s/database_name_here/${WORDPRESS_DB_NAME}/"         wp-config.php
    sed -i "s/username_here/${WORDPRESS_DB_USER}/"              wp-config.php
    sed -i "s/password_here/${WORDPRESS_DB_PASSWORD}/"          wp-config.php
    sed -i "s/localhost/mariadb/"                               wp-config.php

    # Sal e prefisso (facoltativi)
    if [ -n "$WORDPRESS_TABLE_PREFIX" ]; then
        sed -i "s/wp_/${WORDPRESS_TABLE_PREFIX}/" wp-config.php
    fi

    chown www-data:www-data wp-config.php
fi

exec php-fpm
