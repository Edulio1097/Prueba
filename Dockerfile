# Usa una imagen base de PHP
FROM php:8.2-fpm 

# Instalamos dependencias necesarias
RUN apt-get update && apt-get install -y \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    zip \
    git \
    libzip-dev \
    libicu-dev \  
    && docker-php-ext-configure zip \
    && docker-php-ext-install pdo pdo_mysql zip exif pcntl intl  

# Instalamos Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Copiamos el código de la aplicación
COPY . /var/www/html

# Establecemos el directorio de trabajo
WORKDIR /var/www/html

# Instalamos las dependencias de Composer
RUN composer install --no-dev --optimize-autoloader

# Exponemos el puerto 8000 para Laravel
EXPOSE 8000

# Comando para ejecutar php artisan serve
CMD php artisan serve --host=0.0.0.0 --port=8000
