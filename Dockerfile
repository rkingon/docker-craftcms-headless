FROM php:8.2-apache

ENV PORT=80

RUN apt-get update \
    && apt-get -y install git zip libmagickwand-dev imagemagick libzip-dev libpq-dev \
    && pecl install imagick \
    && docker-php-ext-configure pgsql -with-pgsql=/usr/local/pgsql \
    && docker-php-ext-install pdo pdo_pgsql pgsql zip intl bcmath \
    && docker-php-ext-enable imagick

# Apache Mods
RUN a2enmod mpm_prefork
RUN a2enmod rewrite

# Composer
RUN curl --silent --show-error https://getcomposer.org/installer | php
RUN mv composer.phar /usr/local/bin/composer

# Config
ADD ./build-config/php.ini /usr/local/etc/php/conf.d
ADD ./build-config/ports.conf /etc/apache2/ports.conf
ADD ./build-config/000-default.conf /etc/apache2/sites-available/000-default.conf
