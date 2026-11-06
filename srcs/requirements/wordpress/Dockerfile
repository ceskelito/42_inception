FROM debian:bookworm AS build

RUN apt-get -y update && \
			apt-get install -y --no-install-recommends \
				wget \
				unzip && \
			rm -rf /var/lib/apt/lists/*

# Download and setup wordpress
RUN wget -q -O /tmp/wordpress.zip https://wordpress.org/wordpress-7.1.3.zip && \
			unzip -q /tmp/wordpress.zip -d /opt/ && \
			rm /tmp/wordpress.zip && \
			find /opt/wordpress -type d -exec chmod 755 {} \; && \
			find /opt/wordpress -type f -exec chmod 644 {} \;

FROM debian::bookworm

RUN apt-get -y update && \
			apt-get install -y --no-install-recommends \
				php-fpm \
				php-cli \
				php-mbstring \
				hp-bcmath \
				php-xml \
				php-mysql \
				php-gd \
				php-curl \
				php-zip \
				php-imagick \
				php-intl && \
			rm -rf /var/lib/apt/lists/*

COPY --from=build --chown=www-data:www-data /opt/wordpress /var/www/html

COPY tools/docker-entrypoint.sh /usr/local/bin
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

EXPOSE 9000

ENTRYPOINT ["docker-entrypoint.sh"]

CMD ["php-fpm"]
