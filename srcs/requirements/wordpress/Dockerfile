FROM debian:bookworm AS downloader

# wordpress installation dependencies
RUN	set -ex; \
	apt-get -y update; \
	apt-get install -y --no-install-recommends \
		ca-certificates \
		curl \
	; \
	rm -rf /var/lib/apt/lists/*

# install wordpress
RUN	set -eux; \
	version='7.1.3'; \
	sha1='491a78c7676b15dffcc69130c6054b8f49228a91'; \
	\
	curl -o wordpress.tar.gz -fL "https://wordpress.org/wordpress-$version.tar.gz"; \
	echo "$sha1 *wordpress.tar.gz" | sha1sum -c -; \
	\
# upstream tarballs include ./wordpress/ so this gives us /var/www/html/wordpress \
	mkdir -p /var/www/html; \
	tar -xzf wordpress.tar.gz	-C /var/www/html; \
	rm wordpress.tar.gz

FROM debian:bookworm

# this has to be mantained upstreamed with wordpress and debian versions
ARG PHP_VERSION="8.2"

# wordpress php-modules
RUN set -eux ;\
	apt-get -y update; \
	apt-get install -y --no-install-recommends \
		php${PHP_VERSION}-curl \
		php${PHP_VERSION}-dom \
		php${PHP_VERSION}-exif \
		php${PHP_VERSION}-fileinfo \
		php${PHP_VERSION}-fpm \
		php${PHP_VERSION}-igbinary \
		php${PHP_VERSION}-imagick \
		php${PHP_VERSION}-intl \
		php${PHP_VERSION}-mbstring \
		php${PHP_VERSION}-mysqli \
		php${PHP_VERSION}-xml \
		php${PHP_VERSION}-zip \
	; \
	rm -rf /var/lib/apt/lists/*; \
# aliasing to 'php-fpm' the actual php-fpm executable (for CMD) \
	ln -s "$(which php-fpm${PHP_VERSION})" /usr/local/bin/php-fpm

# set recommended PHP.ini settings
# see https://www.php.net/manual/en/opcache.installation.php
RUN set -eux; \
	: "${PHP_INI_DIR:=/etc/php/${PHP_VERSION}/fpm}"; \
	\
	{ \
		echo 'opcache.memory_consumption=128'; \
		echo 'opcache.interned_strings_buffer=8'; \
		echo 'opcache.max_accelerated_files=4000'; \
		echo 'opcache.revalidate_freq=60'; \
		echo 'opcache.fast_shutdown=1'; \
		echo 'opcache.enable_cli=1'; \
	} > "$PHP_INI_DIR/conf.d/99-opcache-recommended.ini"

COPY --from=downloader --chown=www-data:www-data /var/www/html/wordpress /var/www/html/wordpress
COPY --chmod=440 --chown=www-data:www-data conf/www.conf /etc/php/${PHP_VERSION}/fpm/pool.d/www.conf
COPY --chown=www-data:www-data conf/wp-config.php /var/www/html/wordpress
COPY --chmod=550 tools/docker-entrypoint.sh /docker-entrypoint.sh

EXPOSE 9000

ENTRYPOINT ["/docker-entrypoint.sh"]

CMD ["php-fpm", "-F"]
