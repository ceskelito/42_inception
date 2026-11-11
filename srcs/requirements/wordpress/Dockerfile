FROM debian:bookworm AS build

RUN apt-get -y update && \
			apt-get install -y --no-install-recommends \
				wget \
				unzip \
				ca-certificates && \
			rm -rf /var/lib/apt/lists/*

# Download and extract wordpress
RUN wget -q -O /tmp/wordpress.zip https://wordpress.org/wordpress-7.1.3.zip && \
			unzip -q /tmp/wordpress.zip -d /opt/ && \
			rm /tmp/wordpress.zip && \
			find /opt/wordpress -type d -exec chmod 755 {} \; && \
			find /opt/wordpress -type f -exec chmod 644 {} \;

FROM build

RUN apt-get -y update && \
			apt-get install -y --no-install-recommends \
				php-fpm && \
			rm -rf /var/lib/apt/lists/*

# Setup wordpress
# COPY --from=build --chown=www-data:www-data /opt/wordpress /usr/src/wordpress
COPY --from=build --chown=www-data:www-data /opt/wordpress /var/www/html/wordpress

COPY tools/docker-entrypoint.sh /usr/local/bin
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

EXPOSE 9000

ENTRYPOINT ["docker-entrypoint.sh"]

CMD ["php-fpm", "-F"]
