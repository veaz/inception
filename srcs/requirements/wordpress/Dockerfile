FROM debian:bullseye

RUN apt-get update && apt-get install -y \
    php7.4-fpm \
    php7.4-mysqli \
    php7.4-curl \
    php7.4-xml \
    php7.4-mbstring \
    wget \
    unzip \
    && rm -rf /var/lib/apt/lists/*

# Crea el directorio para WordPress
RUN mkdir -p /var/www/html

RUN wget https://wordpress.org/latest.zip -O /tmp/wordpress.zip && \
    unzip /tmp/wordpress.zip -d /var/www/html && \
    rm /tmp/wordpress.zip

# Copia la configuración de PHP-FPM
COPY conf/php-fpm.conf /etc/php/7.4/fpm/php-fpm.conf

# Cambia permisos
RUN chown -R www-data:www-data /var/www/html

# Crea el directorio para el socket y los logs
RUN mkdir -p /run/php && \
    chown www-data:www-data /run/php

EXPOSE 9000

# Modifica el comando para usar la ruta completa
CMD ["/usr/sbin/php-fpm7.4", "-F"]