#!/bin/bash

# Function to check environment variables
check_env_vars() {
    if [ -z "$MYSQL_DATABASE" ] || [ -z "$MYSQL_USER" ] || [ -z "$MYSQL_PASSWORD" ] || [ -z "$MYSQL_ROOT_PASSWORD" ]; then
        echo "❌ Error: Required environment variables are not defined"
        echo "Required: MYSQL_DATABASE, MYSQL_USER, MYSQL_PASSWORD, MYSQL_ROOT_PASSWORD"
        exit 1
    fi
}

# Check environment variables
check_env_vars

echo "🚀 Starting MariaDB..."

# Ensure correct permissions
chown -R mysql:mysql /var/lib/mysql
chmod 777 /var/run/mysqld

# Initialize database if necessary
if [ ! -d "/var/lib/mysql/mysql" ]; then
    mysql_install_db --user=mysql --datadir=/var/lib/mysql
fi

# Create temporary configuration file
cat > /etc/mysql/conf.d/custom.cnf << EOF
[mysqld]
skip-networking=0
skip-bind-address
EOF

# Start MySQL service in background
echo "📦 Starting MySQL..."
mysqld --user=mysql --datadir=/var/lib/mysql &

# Wait for MySQL to be available
echo "⏳ Waiting for MySQL to be available..."
until mysqladmin ping >/dev/null 2>&1; do
    echo "⌛ Waiting for connection..."
    sleep 1
done
echo "✅ MySQL is available"

# Environment variables
db_name=${MYSQL_DATABASE}
db_user=${MYSQL_USER}
db_pwd=${MYSQL_PASSWORD}
root_pwd=${MYSQL_ROOT_PASSWORD}

# Create and configure the database
echo "🔧 Configuring database..."

# First configure the root password
mysqladmin -u root password "$root_pwd"

# Then create the database and user
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

# Stop MySQL service in background
killall mysqld
sleep 5

echo "🚀 Starting MySQL in foreground..."
exec mysqld --user=mysql --console --bind-address=0.0.0.0