FROM php:7.4-fpm
#RUN pecl install xdebug \
    #&& docker-php-ext-enable xdebug
RUN apt-get update
RUN apt-get install -y git libzip-dev vim
RUN docker-php-ext-install zip
RUN docker-php-ext-install mysqli
RUN docker-php-ext-install pdo_mysql
RUN apt-get update -y && apt-get install -y libpng-dev
RUN apt-get update && apt-get install -y zlib1g-dev
RUN docker-php-ext-install gd
RUN curl -sS https://getcomposer.org/installer \
    | php -- --install-dir=/usr/local/bin --filename=composer
RUN printf '[PHP]\ndate.timezone = "Asia/Manila"\n' > /usr/local/etc/php/conf.d/tzone.ini
COPY ./docker/php/uploads.ini /usr/local/etc/php/conf.d/uploads.ini
