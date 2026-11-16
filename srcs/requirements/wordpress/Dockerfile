FROM debian:bookworm

ARG PHP_VERSION="8.2"
ARG WP_VERSION="7.1.3"

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
	version="${WP_VERSION}"; \
	sha1='491a78c7676b15dffcc69130c6054b8f49228a91'; \
	\
	curl -o wordpress.tar.gz -fL "https://wordpress.org/wordpress-$version.tar.gz"; \
	echo "$sha1 *wordpress.tar.gz" | sha1sum -c -; \
	\
# upstream tarballs include ./wordpress/ so this gives us /var/www/html/wordpress \
	mkdir -p /var/www/html; \
	tar -xzf wordpress.tar.gz	-C /var/www/html; \
	rm wordpress.tar.gz; \
	\
	chown -R www-data:www-data /var/www/html/wordpress;

# wordpress php-modules
RUN set -eux ;\
	version="${PHP_VERSION}"; \
	\
	apt-get -y update; \
	apt-get install -y --no-install-recommends \
		php$version-curl \
		php$version-dom \
		php$version-exif \
		php$version-fileinfo \
		php$version-fpm \
		php$version-igbinary \
		php$version-imagick \
		php$version-intl \
		php$version-mbstring \
		php$version-mysqli \
		php$version-xml \
		php$version-zip \
	; \
	rm -rf /var/lib/apt/lists/*

# set recommended PHP.ini settings
# see https://secure.php.net/manual/en/opcache.installation.php
RUN set -eux; \
	version=${PHP_VERSION}; \
	: "${PHP_INI_DIR:=/etc/php/$version/fpm}"; \
	\
	{ \
		echo 'opcache.memory_consumption=128'; \
		echo 'opcache.interned_strings_buffer=8'; \
		echo 'opcache.max_accelerated_files=4000'; \
		echo 'opcache.revalidate_freq=2'; \
	} > "$PHP_INI_DIR/conf.d/99-opcache-recommended.ini"

# aliasing to 'php-fpm' the actual php-fpm executable
RUN	set -eux; \
	version="${PHP_VERSION}"; \
	executable="$(which php-fpm$version)"; \
	dir="$(dirname $executable)"; \
	\
	ln -s "$executable" "$dir/php-fpm"

# copy php configuration files and entrypoint scripts
COPY --chmod=440 --chown=www-data:www-data conf/www.conf /etc/php/${PHP_VERSION}/fpm/pool.d/www.conf
COPY --chown=www-data:www-data conf/wp-config.php /var/www/html/wordpress
COPY --chmod=550 tools/docker-entrypoint.sh /

EXPOSE 9000

ENTRYPOINT ["/docker-entrypoint.sh"]

CMD ["php-fpm", "-F"]
