# Debian 11
FROM debian:bullseye

RUN apt-get update && apt-get install -y mariadb-server mariadb-client && \
    mkdir -p /var/run/mysqld && \
    chown -R mysql:mysql /var/run/mysqld /var/lib/mysql

# Copiar el script de inicialización
COPY script.sh /script.sh
COPY tools/init.sql /init.sql

# Inicializar la base de datos
RUN chmod +x /script.sh && \
    mysql_install_db --user=mysql --datadir=/var/lib/mysql && \
    chown -R mysql:mysql /var/lib/mysql

# Exponer el puerto de MariaDB
EXPOSE 3306

# Iniciar MariaDB usando el script
CMD ["bash", "/script.sh"]