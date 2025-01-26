<?php
// Configuración de base de datos
define('DB_NAME', getenv('MYSQL_DATABASE'));
define('DB_USER', getenv('MYSQL_USER'));
define('DB_PASSWORD', getenv('MYSQL_PASSWORD'));
define('DB_HOST', 'mariadb');
define('DB_CHARSET', 'utf8');
define('DB_COLLATE', '');

// Claves únicas y salts
define('AUTH_KEY',         'your_unique_phrase');
define('SECURE_AUTH_KEY',  'your_unique_phrase');
define('LOGGED_IN_KEY',    'your_unique_phrase');
define('NONCE_KEY',        'your_unique_phrase');
define('AUTH_SALT',        'your_unique_phrase');
define('SECURE_AUTH_SALT', 'your_unique_phrase');
define('LOGGED_IN_SALT',   'your_unique_phrase');
define('NONCE_SALT',       'your_unique_phrase');

// Prefijo de las tablas
$table_prefix = 'wp_';

// Modo de depuración
define('WP_DEBUG', false);

// Configuración de URLs (opcional)
define('WP_HOME', getenv('WP_SITE_URL'));
define('WP_SITEURL', getenv('WP_SITE_URL'));

// Fin del archivo
