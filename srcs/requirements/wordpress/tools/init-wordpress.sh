#!/bin/bash

echo "🚀 Starting WordPress initialization script..."

# Verificar permisos y directorios
echo "🔧 Verificando permisos y directorios..."
mkdir -p /run/php
chown -R www-data:www-data /run/php /var/www/html
chmod 755 /run/php

# Wait for MariaDB to be available
echo "⌛ Waiting for MariaDB to be available..."
max_attempts=30
attempt=1

while [ $attempt -le $max_attempts ]; do
    if mysql -h mariadb -u "${MYSQL_USER}" -p"${MYSQL_PASSWORD}" "${MYSQL_DATABASE}" -e "SELECT 1" &>/dev/null; then
        echo "✅ MariaDB connection established"
        break
    fi
    echo "⏳ Attempt $attempt of $max_attempts - Waiting for MariaDB..."
    sleep 5
    attempt=$((attempt + 1))
done

if [ $attempt -gt $max_attempts ]; then
    echo "❌ Error: Could not connect to MariaDB after $max_attempts attempts"
    exit 1
fi

cd /var/www/html/wordpress
echo "📂 Directorio actual: $(pwd)"

# Mejorar la configuración de permisos
echo "🔧 Configurando permisos avanzados..."
find /var/www/html -type d -exec chmod 755 {} \;
find /var/www/html -type f -exec chmod 644 {} \;
chown -R www-data:www-data /var/www/html

# Crear wp-config.php si no existe
if [ ! -f wp-config.php ]; then
    echo "📝 Creating wp-config.php..."
    wp config create \
        --dbname="${MYSQL_DATABASE}" \
        --dbuser="${MYSQL_USER}" \
        --dbpass="${MYSQL_PASSWORD}" \
        --dbhost=mariadb \
        --allow-root
    echo "✅ wp-config.php created"
fi

# Instalar WordPress si no está instalado
if ! wp core is-installed --allow-root; then
    echo "🔧 Installing WordPress..."
    
    # Instalar WordPress
    wp core install \
        --url="${WP_SITE_URL}" \
        --title="${WP_TITLE}" \
        --admin_user="${WP_ADMIN_USER}" \
        --admin_password="${WP_ADMIN_PASSWORD}" \
        --admin_email="${WP_ADMIN_EMAIL}" \
        --skip-email \
        --allow-root
    
    echo "👤 Creating secondary user..."
    # Crear usuario secundario
    wp user create "${WP_USER}" "${WP_USER_EMAIL}" \
        --role=author \
        --user_pass="${WP_USER_PASSWORD}" \
        --allow-root

    echo "✅ WordPress installed successfully"
    echo "🔑 Admin credentials:"
    echo "   Username: ${WP_ADMIN_USER}"
    echo "   Password: ${WP_ADMIN_PASSWORD}"
    echo "🔑 Secondary user credentials:"
    echo "   Username: ${WP_USER}"
    echo "   Password: ${WP_USER_PASSWORD}"

    # Verificar y activar el tema por defecto
    wp theme activate twentytwentyone --allow-root || true

    # Limpiar caché
    wp cache flush --allow-root || true
fi

# Antes de iniciar PHP-FPM, verificar la configuración
echo "🔍 Verificando configuración de PHP-FPM..."
php-fpm7.4 -t

# Iniciar PHP-FPM con más verbosidad
echo "🚀 Starting PHP-FPM..."
exec php-fpm7.4 -F -R 
