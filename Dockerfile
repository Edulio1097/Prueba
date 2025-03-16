# Usa una imagen base de PHP
FROM php:8.2-fpm  # Cambiar a PHP 8.2 para resolver los problemas de compatibilidad con otras dependencias

# Instalamos dependencias necesarias
RUN apt-get update && apt-get install -y \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    zip \
    git \
    libzip-dev \
    libicu-dev \  # Dependencia necesaria para la extensión intl
    && docker-php-ext-configure zip \
    && docker-php-ext-install pdo pdo_mysql zip exif pcntl intl  # Habilitamos intl aquí

# Instalamos Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Copiamos el código de la aplicación
COPY . /var/www/html

# Establecemos el directorio de trabajo
WORKDIR /var/www/html

# Instalamos las dependencias de Composer
RUN composer install --no-dev --optimize-autoloader

# Expone el puerto
EXPOSE 9000

# Comando para ejecutar PHP-FPM
CMD ["php-fpm"]
