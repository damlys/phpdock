#:latest
FROM php:fpm
USER root
WORKDIR /app
ENTRYPOINT ["entrypoint.bash"]
CMD ["php", "--version"]
HEALTHCHECK NONE
EXPOSE 80 9000

ENV VERSION="undefined"

RUN groupadd --gid 1000 deploy \
&& useradd --uid 1000 --gid deploy --shell /bin/bash --create-home deploy

# Install Composer
RUN php -r 'copy("https://getcomposer.org/installer", "/usr/local/bin/composer-installer");' \
&& php /usr/local/bin/composer-installer --install-dir=/usr/local/bin --filename=composer \
&& rm /usr/local/bin/composer-installer
ENV COMPOSER_ALLOW_SUPERUSER="1"

# Set Composer cache directories
RUN rm -rf /var/cache/composer \
&& mkdir --parents /var/cache/composer \
&& chmod --recursive a+rw /var/cache/composer \
&& composer config --global cache-dir /var/cache/composer \
&& su --command "composer config --global cache-dir /var/cache/composer" deploy

# Various things combined to reduce the size of the image:
# - Bash completion
# - Nginx
# - `gettext` package contains `envsubst` tool
# - `libfcgi0ldbl` package contains `cgi-fcgi` tool
RUN apt-get update && apt-get install --yes --no-install-recommends \
  gnupg \
&& echo 'deb http://nginx.org/packages/mainline/debian/ stretch nginx' >> /etc/apt/sources.list \
&& curl -fsSL http://nginx.org/keys/nginx_signing.key -o /root/nginx_signing.key \
&& apt-key add /root/nginx_signing.key \
&& apt-get update && apt-get install --yes --no-install-recommends \
  bash-completion \
  gettext \
  git \
  nginx \
&& apt-get install --yes \
  libfcgi0ldbl \
&& apt-get clean && rm -rf /var/lib/apt/lists/* \
&& service nginx stop \
&& echo ". /etc/bash_completion" >> ~/.bashrc \
&& composer global require bamarni/symfony-console-autocomplete \
&& composer clear-cache \
&& echo "$(php ~/.composer/vendor/bin/symfony-autocomplete --shell bash composer)" > /etc/bash_completion.d/composer

# PHP dependencies
# Note: Xdebug is disabled by default. Use `docker-php-ext-enable xdebug` command to enable it
RUN apt-get update && apt-get install --yes --no-install-recommends \
  libpq-dev \
  libzip-dev \
  zlib1g-dev \
&& apt-get clean && rm -rf /var/lib/apt/lists/* \
&& pecl install \
  redis \
  xdebug \
&& pecl clear-cache \
&& docker-php-ext-install \
  opcache \
  pdo_mysql \
  pdo_pgsql \
  zip \
&& docker-php-ext-enable \
  redis

# Copy Nginx configuration and set default runtime values
COPY etc/nginx.template.conf /etc/nginx/nginx.template.conf
ENV NGINX_CGI_SERVER_HOST="127.0.0.1"
ENV NGINX_CGI_SERVER_PORT="9000"
# debug|info|notice|warn|error|crit|alert|emerg (http://nginx.org/en/docs/ngx_core_module.html#error_log)
ENV NGINX_LOG_LEVEL="error"
ENV NGINX_WORKERS_COUNT="1"

# Copy PHP configuration and set default runtime values
COPY etc/php.ini /usr/local/etc/php/conf.d/zzz-php.ini
COPY etc/php-fpm.conf /usr/local/etc/php-fpm.d/zzz-php-fpm.conf
COPY etc/xdebug.ini /usr/local/etc/php/conf.d/zzz-xdebug.ini
# debug|notice|warning|error|alert (https://www.php.net/manual/en/install.fpm.configuration.php#log-level)
ENV FPM_LOG_LEVEL="error"
ENV FPM_WORKERS_COUNT="1"
ENV OPCACHE_ENABLE="on"
# E_ALL|E_STRICT|E_NOTICE|E_WARNING|E_ERROR|E_CORE_ERROR (https://www.php.net/manual/en/errorfunc.constants.php)
ENV PHP_LOG_LEVEL="E_ERROR"
ENV XDEBUG_ENABLE="off"
ENV XDEBUG_IDE_KEY="DOCKER"
ENV XDEBUG_REMOTE_AUTOSTART="off"
ENV XDEBUG_REMOTE_CONNECT_BACK="off"
ENV XDEBUG_REMOTE_HOST="127.0.0.1"
ENV XDEBUG_REMOTE_PORT="9000"

# Copy global container scripts
COPY bin/*.bash /usr/local/bin/
RUN chmod a+x /usr/local/bin/*.bash
