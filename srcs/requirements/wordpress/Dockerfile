FROM debian:bullseye

RUN apt-get update && apt-get install -y \
    php7.4-fpm \
    php7.4-mysqli \
    php7.4-curl \
    php7.4-xml \
    php7.4-mbstring \
    mariadb-client \
    wget \
    unzip \
    && rm -rf /var/lib/apt/lists/*

# Instalar WP-CLI
RUN wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
    chmod +x wp-cli.phar && \
    mv wp-cli.phar /usr/local/bin/wp

# Crea el directorio para WordPress
RUN mkdir -p /var/www/html

RUN wget https://wordpress.org/latest.zip -O /tmp/wordpress.zip && \
    unzip /tmp/wordpress.zip -d /var/www/html && \
    rm /tmp/wordpress.zip

# Copia wp-config.php al directorio correcto
COPY conf/wp-config.php /var/www/html/wordpress/wp-config.php

# Copia la configuración de PHP-FPM
COPY conf/php-fpm.conf /etc/php/7.4/fpm/php-fpm.conf

# Cambia permisos
RUN chown -R www-data:www-data /var/www/html

# Crea el directorio para el socket y los logs
RUN mkdir -p /run/php && \
    chown www-data:www-data /run/php

# Copiar script de inicialización
COPY tools/init-wordpress.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/init-wordpress.sh

EXPOSE 9000

CMD ["/usr/local/bin/init-wordpress.sh"]