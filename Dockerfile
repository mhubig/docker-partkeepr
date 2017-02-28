FROM php:7-apache
MAINTAINER Markus Hubig <mh@imko.de>

ENV VERSION 1.2.0

RUN set -ex \
    && apt-get update && apt-get install -y \
        bzip2 \
        libcurl4-openssl-dev \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libicu-dev \
        libxml2-dev \
        libpng12-dev \
        libldap2-dev \
    --no-install-recommends && rm -r /var/lib/apt/lists/* \
    \
    && docker-php-ext-configure ldap --with-libdir=lib/x86_64-linux-gnu/ \
    && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install -j$(nproc) curl ldap bcmath gd dom intl opcache pdo pdo_mysql \
    \
    && pecl install apcu-beta \
    && docker-php-ext-enable apcu \
    \
    && cd /var/www/html \
    && curl -sL https://github.com/partkeepr/PartKeepr/releases/download/${VERSION}/partkeepr-${VERSION}.tbz2 |tar -xj --strip 1 \
    && chown -R www-data:www-data /var/www/html \
    \
    && a2enmod rewrite

COPY php.ini /usr/local/etc/php/php.ini
COPY apache.conf /etc/apache2/sites-available/000-default.conf

VOLUME /var/www/html/data
