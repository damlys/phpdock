#!/bin/bash
set -ex

apt-get update

# install Nginx
apt-get install --yes --no-install-recommends \
  nginx

service nginx stop

# install PHP extensions
apt-get install --yes --no-install-recommends \
  libicu-dev \
  libpq-dev \
  libzip-dev \
  unzip \
  zip \
  zlib1g-dev

pecl install \
  redis

docker-php-ext-install \
  intl \
  opcache \
  pdo_mysql \
  pdo_pgsql \
  zip

docker-php-ext-enable \
  redis \
  sodium

# install Composer
apt-get install --yes --no-install-recommends git
php -r 'copy("https://getcomposer.org/installer", "/usr/local/bin/composer-installer");'
php /usr/local/bin/composer-installer --install-dir=/usr/local/bin --filename=composer
rm /usr/local/bin/composer-installer

# delete default configs
rm \
  /etc/nginx/nginx.conf \
  /etc/nginx/sites-available/* \
  /etc/nginx/sites-enabled/* \
  /usr/local/etc/php-fpm.d/* \
  /usr/local/etc/php/conf.d/*

# cleanup
apt-get clean && rm -rf /var/lib/apt/lists/*
pecl clear-cache
rm -rf /tmp/*
