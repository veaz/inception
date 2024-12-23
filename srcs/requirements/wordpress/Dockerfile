FROM debian:11.11

RUN apt-get update && apt-get -y install \
    curl \
    php7.4-fpm \
    php7.4-mysqli \
    mariadb-client

RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
    && chmod +x wp-cli.phar \
    && mv wp-cli.phar /usr/local/bin/wp

COPY script.sh /script.sh

CMD ["/bin/bash", "/script.sh"]
