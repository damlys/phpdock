FROM php:8.0-fpm AS rte
# $ cat /etc/passwd | grep 'www-data'
# www-data:x:33:33:www-data:/var/www:/usr/sbin/nologin
# $ cat /etc/group | grep 'www-data'
# www-data:x:33:

# Install Nginx
RUN apt-get update && apt-get install --yes --no-install-recommends \
  gettext \
  nginx \
&& apt-get clean && rm -rf /var/lib/apt/lists/* \
&& service nginx stop \
&& rm \
  /etc/nginx/nginx.conf \
  /etc/nginx/sites-available/* \
  /etc/nginx/sites-enabled/*

# Install PHP extensions
RUN rm \
  /usr/local/etc/php-fpm.d/* \
  /usr/local/etc/php/conf.d/* \
&& apt-get update && apt-get install --yes --no-install-recommends \
  libpq-dev \
  libzip-dev \
  unzip \
  zip \
  zlib1g-dev \
&& apt-get clean && rm -rf /var/lib/apt/lists/* \
&& pecl install \
  redis \
&& pecl clear-cache \
&& docker-php-ext-install \
  opcache \
  pdo_mysql \
  pdo_pgsql \
  zip \
&& docker-php-ext-enable \
  redis \
  sodium

# Install Composer
RUN apt-get update && apt-get install --yes --no-install-recommends \
  git \
&& apt-get clean && rm -rf /var/lib/apt/lists/* \
&& php -r 'copy("https://getcomposer.org/installer", "/usr/local/bin/composer-installer");' \
&& php /usr/local/bin/composer-installer --install-dir=/usr/local/bin --filename=composer \
&& rm /usr/local/bin/composer-installer

# Nginx configuration
COPY ./etc/nginx.template.conf /etc/nginx/nginx.template.conf
ENV NGINX_WORKERS_COUNT="1"
ENV NGINX_CGI_SERVER_HOST="127.0.0.1"
ENV NGINX_CGI_SERVER_PORT="9000"
ENV NGINX_ACCESS_LOG="/dev/stdout"
ENV NGINX_ERROR_LOG="/dev/stderr"
# debug|info|notice|warn|error|crit|alert|emerg (http://nginx.org/en/docs/ngx_core_module.html#error_log)
ENV NGINX_LOG_LEVEL="error"

# FPM configuration
COPY ./etc/php-fpm.conf /usr/local/etc/php-fpm.d/php-fpm.conf
ENV FPM_WORKERS_COUNT="2"
# "/proc/self/fd/1" does not work for FPM_ACCESS_LOG
ENV FPM_ACCESS_LOG="/proc/self/fd/2"
ENV FPM_ERROR_LOG="/proc/self/fd/2"
# debug|notice|warning|error|alert (https://www.php.net/manual/en/install.fpm.configuration.php#log-level)
ENV FPM_LOG_LEVEL="error"

# PHP configuration
COPY ./etc/php.ini /usr/local/etc/php/conf.d/php.ini
ENV PHP_OPCACHE_ENABLE="true"
ENV PHP_ERROR_LOG="/proc/self/fd/2"
# E_ALL|E_STRICT|E_NOTICE|E_WARNING|E_ERROR|E_CORE_ERROR (https://www.php.net/manual/en/errorfunc.constants.php)
ENV PHP_LOG_LEVEL="E_ERROR"

# Composer configuration
ENV COMPOSER_ALLOW_SUPERUSER="1"

# Entrypoint
COPY ./bin/entrypoint.bash /usr/local/bin/entrypoint.bash
RUN chmod a+x /usr/local/bin/entrypoint.bash
ENTRYPOINT ["entrypoint.bash"]
CMD ["bash", "-c", "php-fpm --daemonize && nginx"]
EXPOSE 8080 9000
HEALTHCHECK NONE
WORKDIR /app


FROM rte AS sdk

# Install Composer bash completion
RUN apt-get update && apt-get install --yes --no-install-recommends \
  bash-completion \
&& apt-get clean && rm -rf /var/lib/apt/lists/* \
&& echo ". /etc/bash_completion" >> ~/.bashrc \
&& composer global require bamarni/symfony-console-autocomplete \
&& composer clear-cache \
&& echo "$(php ~/.composer/vendor/bin/symfony-autocomplete --shell bash composer)" > /etc/bash_completion.d/composer

# Install Xdebug
RUN pecl install \
  xdebug \
&& pecl clear-cache \
&& docker-php-ext-enable \
  xdebug

# Xdebug configuration
COPY ./etc/xdebug.ini /usr/local/etc/php/conf.d/xdebug.ini
ENV XDEBUG_MODE="off"
ENV XDEBUG_CONFIG=""
ENV XDEBUG_OUTPUT_DIR="/tmp"


FROM sdk AS app

ENV VERSION="0.2.1"

COPY ./app/composer.json ./app/composer.lock /app/
RUN composer install \
&& composer clear-cache

COPY ./app /app
RUN composer run-script build \
&& chmod --recursive a+r /app \
&& chmod --recursive a+x /app/bin/* \
&& chown --recursive www-data:www-data /app/logs \
&& chmod --recursive a+w /app/logs
