#!/bin/bash

echo "🚀 Iniciando script de WordPress..."

# Esperar a que MariaDB esté disponible
echo "⌛ Esperando a que MariaDB esté disponible..."
max_attempts=30
attempt=1

while [ $attempt -le $max_attempts ]; do
    if mysql -h mariadb -u "${MYSQL_USER}" -p"${MYSQL_PASSWORD}" "${MYSQL_DATABASE}" -e "SELECT 1" &>/dev/null; then
        echo "✅ Conexión a MariaDB establecida"
        break
    fi
    echo "⏳ Intento $attempt de $max_attempts - Esperando a MariaDB..."
    sleep 5
    attempt=$((attempt + 1))
done

if [ $attempt -gt $max_attempts ]; then
    echo "❌ Error: No se pudo conectar a MariaDB después de $max_attempts intentos"
    exit 1
fi

cd /var/www/html/wordpress
echo "📂 Directorio actual: $(pwd)"

# Configurar permisos
echo "🔧 Configurando permisos..."
chown -R www-data:www-data /var/www/html
chmod -R 755 /var/www/html
echo "✅ Permisos configurados"

# Crear wp-config.php si no existe
if [ ! -f wp-config.php ]; then
    echo "📝 Creando wp-config.php..."
    wp config create \
        --dbname="${MYSQL_DATABASE}" \
        --dbuser="${MYSQL_USER}" \
        --dbpass="${MYSQL_PASSWORD}" \
        --dbhost=mariadb \
        --allow-root
    echo "✅ wp-config.php creado"
fi

# Instalar WordPress si no está instalado
if ! wp core is-installed --allow-root; then
    echo "🔧 Instalando WordPress..."
    
    # Instalar WordPress
    wp core install \
        --url="${WP_SITE_URL}" \
        --title="${WP_TITLE}" \
        --admin_user="${WP_ADMIN_USER}" \
        --admin_password="${WP_ADMIN_PASSWORD}" \
        --admin_email="${WP_ADMIN_EMAIL}" \
        --skip-email \
        --allow-root
    
    echo "👤 Creando usuario secundario..."
    # Crear usuario secundario
    wp user create "${WP_USER}" "${WP_USER_EMAIL}" \
        --role=author \
        --user_pass="${WP_USER_PASSWORD}" \
        --allow-root

    echo "✅ WordPress instalado con éxito"
    echo "🔑 Credenciales de administrador:"
    echo "   Usuario: ${WP_ADMIN_USER}"
    echo "   Contraseña: ${WP_ADMIN_PASSWORD}"
    echo "🔑 Credenciales de usuario secundario:"
    echo "   Usuario: ${WP_USER}"
    echo "   Contraseña: ${WP_USER_PASSWORD}"
fi

echo "🚀 Iniciando PHP-FPM..."
exec php-fpm7.4 -F 