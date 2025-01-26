# Debian 11
FROM debian:bullseye

RUN apt-get update && apt-get install -y mariadb-server mariadb-client && \
    mkdir -p /run/mysqld && \
    chown -R mysql:mysql /run/mysqld && \
    mkdir -p /var/lib/mysql && \
    chown -R mysql:mysql /var/lib/mysql

# Copiar el script de inicialización
COPY script.sh /script.sh
RUN chmod +x /script.sh

# Inicializar la base de datos
RUN mysql_install_db --user=mysql --datadir=/var/lib/mysql

# Exponer el puerto de MariaDB
EXPOSE 3306

# Iniciar MariaDB usando el script
CMD ["bash", "/script.sh"]