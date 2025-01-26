#!/bin/bash

# Función para esperar a que MariaDB esté disponible
wait_for_mariadb() {
    echo "Esperando a que MariaDB esté disponible..."
    for i in {1..30}; do
        if mysqladmin ping -h mariadb --silent; then
            echo "MariaDB está listo"
            return 0
        fi
        echo "Intento $i: MariaDB no está listo aún..."
        sleep 2
    done
    echo "Error: No se pudo conectar a MariaDB después de 60 segundos"
    return 1
}

# Esperar a que MariaDB esté disponible
wait_for_mariadb || exit 1

cd /var/www/html/wordpress

# Asegurarse de que los permisos sean correctos
chown -R www-data:www-data /var/www/html
chmod -R 755 /var/www/html

# Verificar si WordPress ya está instalado
if ! wp core is-installed --allow-root; then
    echo "Instalando WordPress..."
    wp core install \
        --allow-root \
        --url=${WP_SITE_URL} \
        --title="${WP_TITLE}" \
        --admin_user=${MYSQL_USER} \
        --admin_password=${MYSQL_PASSWORD} \
        --admin_email=${WP_ADMIN_EMAIL} \
        --skip-email

    # Configurar el tema y plugins si es necesario
    wp theme activate twentytwentythree --allow-root
    
    echo "WordPress instalado correctamente"
fi

echo "Iniciando PHP-FPM..."
exec php-fpm7.4 -F 