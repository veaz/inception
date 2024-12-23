FROM debian:bullseye

RUN apt-get update && apt-get install -y mariadb-server mariadb-client && \
    mkdir -p /run/mysqld && \
    chown -R mysql:mysql /run/mysqld && \
    mkdir -p /var/lib/mysql && \
    chown -R mysql:mysql /var/lib/mysql

# Exponer el puerto de MariaDB
EXPOSE 3306

# Iniciar MariaDB
CMD ["bash", "/script.sh"]
CMD ["mysqld", "--user=mysql"]