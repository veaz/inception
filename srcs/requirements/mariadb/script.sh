#!/bin/bash

# Función para verificar variables de entorno
check_env_vars() {
    if [ -z "$MYSQL_DATABASE" ] || [ -z "$MYSQL_USER" ] || [ -z "$MYSQL_PASSWORD" ] || [ -z "$MYSQL_ROOT_PASSWORD" ]; then
        echo "❌ Error: Required environment variables are not defined"
        echo "Required: MYSQL_DATABASE, MYSQL_USER, MYSQL_PASSWORD, MYSQL_ROOT_PASSWORD"
        exit 1
    fi
}

# Verificar variables de entorno
check_env_vars

echo "🚀 Starting MariaDB..."

# Asegurar permisos correctos
chown -R mysql:mysql /var/lib/mysql
chmod 777 /var/run/mysqld

# Inicializar la base de datos si es necesario
if [ ! -d "/var/lib/mysql/mysql" ]; then
    mysql_install_db --user=mysql --datadir=/var/lib/mysql
fi

# Crear archivo de configuración temporal
cat > /etc/mysql/conf.d/custom.cnf << EOF
[mysqld]
skip-networking=0
skip-bind-address
EOF

# Iniciar el servicio de MySQL en segundo plano
echo "📦 Starting MySQL..."
mysqld --user=mysql --datadir=/var/lib/mysql &

# Esperar a que MySQL esté disponible
echo "⏳ Waiting for MySQL to be available..."
until mysqladmin ping >/dev/null 2>&1; do
    echo "⌛ Waiting for connection..."
    sleep 1
done
echo "✅ MySQL is available"

# Variables de entorno
db_name=${MYSQL_DATABASE}
db_user=${MYSQL_USER}
db_pwd=${MYSQL_PASSWORD}
root_pwd=${MYSQL_ROOT_PASSWORD}

# Crear y configurar la base de datos
echo "🔧 Configurando base de datos..."

# Primero configuramos la contraseña de root
mysqladmin -u root password "$root_pwd"

# Luego creamos la base de datos y el usuario
mysql -u root -p"$root_pwd" << EOF
CREATE DATABASE IF NOT EXISTS $db_name;
CREATE USER IF NOT EXISTS '$db_user'@'%' IDENTIFIED BY '$db_pwd';
GRANT ALL PRIVILEGES ON $db_name.* TO '$db_user'@'%';
FLUSH PRIVILEGES;
EOF

if [ $? -eq 0 ]; then
    echo "✅ Database configured correctly"
    echo "✅ User $db_user created"
    echo "✅ Database $db_name created"
else
    echo "❌ Error in database configuration"
    exit 1
fi

# Detener el proceso de MySQL en segundo plano
killall mysqld
sleep 5

echo "🚀 Starting MySQL in foreground..."
exec mysqld --user=mysql --console --bind-address=0.0.0.0