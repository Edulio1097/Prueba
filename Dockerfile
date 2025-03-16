# Usamos una imagen oficial de PHP
FROM php:8.1-fpm

# Instalamos dependencias necesarias para Laravel
RUN apt-get update && apt-get install -y libpng-dev libjpeg-dev libfreetype6-dev git zip unzip && \
    docker-php-ext-configure gd --with-freetype --with-jpeg && \
    docker-php-ext-install gd pdo pdo_mysql

# Instalamos Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Configuramos el directorio de trabajo
WORKDIR /var/www

# Copiamos los archivos de la aplicación en el contenedor
COPY . .

# Instalamos las dependencias de Composer
RUN composer install --no-dev --optimize-autoloader

# Copiamos el archivo .env
COPY .env.example .env

# Generamos la clave de la aplicación
RUN php artisan key:generate

# Expone el puerto 9000
EXPOSE 9000

# Configuramos el comando de inicio
CMD ["php-fpm"]
