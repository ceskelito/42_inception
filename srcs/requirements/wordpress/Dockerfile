FROM debian:bookworm AS build

ARG WP_VERSION="7.1.3"

# Install wordpress download dependencies
RUN apt-get -y update && \
			apt-get install -y --no-install-recommends \
				wget \
				unzip \
				ca-certificates && \
			rm -rf /var/lib/apt/lists/*

# Download and extract wordpress
RUN wget -q -O /tmp/wordpress-${WP_VERSION}.zip https://wordpress.org/wordpress-${WP_VERSION}.zip && \
			unzip -q /tmp/wordpress-${WP_VERSION}.zip -d /opt/ && \
			rm /tmp/wordpress-${WP_VERSION}.zip && \
			find /opt/wordpress -type d -exec chmod 755 {} \; && \
			find /opt/wordpress -type f -exec chmod 644 {} \;

FROM build

ARG PHP_VERSION="8.2"

# Install wordpress php-modules dependencies
RUN apt-get -y update && \
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
				php${PHP_VERSION}-zip && \
			rm -rf /var/lib/apt/lists/*

# Aliasing to 'php-fpm' the actual php-fpm executable
RUN	ln -s $(which php-fpm${PHP_VERSION}) $(dirname $(which php-fpm${PHP_VERSION}))/php-fpm

# Install wordpress from build stage
COPY --from=build --chown=www-data:www-data /opt/wordpress /var/www/html/wordpress

# Copy php configuration files and entrypoint scripts
COPY --chmod=440 --chown=ww-data:www-data conf/www.conf /etc/php/${PHP_VERSION}/fpm/pool.d/www.conf
COPY --chmod=550 tools/docker-entrypoint.sh /usr/local/bin

EXPOSE 9000

ENTRYPOINT ["docker-entrypoint.sh"]

CMD ["php-fpm", "-F"]
