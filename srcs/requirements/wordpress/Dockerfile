FROM debian:bookworm as build

RUN apt-get -y update && \
      apt-get install -y --no-install-recommends \
        curl \
        wget \
        unzip \
        php-fpm \
        php-cli \
        php-mbstring \
        php-bcmath \
        php-xml \
        php-mysql \
        php-gd \
        php-curl \
        php-zip \
        php-imagick \
        php-intl

RUN wget -O wordpress.zip https://wordpress.org/wordpress-7.1.3.zip && \
      unzip wordpress.zip -d /var/www/html/ && \
      chown -R www-data:www-data /var/www/html/wordpress/ && \
      find /var/www/html/wordpress -type d -exec chmod 755 {} \; && \
      find /var/www/html/wordpress -type f -exec chmod 644 {} \;

ENTRYPOINT ["docker-entrypoint.sh"]
