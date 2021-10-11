FROM php:8.0-fpm
USER root
RUN groupadd --gid 1000 deploy \
&& useradd --uid 1000 --gid deploy --shell /bin/bash --create-home deploy
WORKDIR /app
EXPOSE 8080 9000
HEALTHCHECK NONE

# Install Nginx
RUN apt-get update && apt-get install --yes --no-install-recommends \
  gettext \
  nginx \
&& apt-get clean && rm -rf /var/lib/apt/lists/* \
&& service nginx stop \
&& rm /etc/nginx/nginx.conf

# Install PHP extensions
RUN apt-get update && apt-get install --yes --no-install-recommends \
  libpq-dev \
  libzip-dev \
  unzip \
  zip \
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
  redis \
  xdebug

# Install Composer
RUN apt-get update && apt-get install --yes --no-install-recommends \
  git \
&& apt-get clean && rm -rf /var/lib/apt/lists/* \
&& php -r 'copy("https://getcomposer.org/installer", "/usr/local/bin/composer-installer");' \
&& php /usr/local/bin/composer-installer --install-dir=/usr/local/bin --filename=composer \
&& rm /usr/local/bin/composer-installer
ENV COMPOSER_ALLOW_SUPERUSER="1"

# Configure Composer cache directory
RUN rm -rf /var/cache/composer \
&& mkdir --parents /var/cache/composer \
&& chmod --recursive a+rw /var/cache/composer \
&& composer config --global cache-dir /var/cache/composer \
&& su --command "composer config --global cache-dir /var/cache/composer" deploy

# Install Composer bash completion
RUN apt-get update && apt-get install --yes --no-install-recommends \
  bash-completion \
&& apt-get clean && rm -rf /var/lib/apt/lists/* \
&& echo ". /etc/bash_completion" >> ~/.bashrc \
&& echo ". /etc/bash_completion" >> /home/deploy/.bashrc \
&& composer global require bamarni/symfony-console-autocomplete \
&& composer clear-cache \
&& echo "$(php ~/.composer/vendor/bin/symfony-autocomplete --shell bash composer)" > /etc/bash_completion.d/composer

# Nginx configuration
COPY ./etc/nginx.template.conf /etc/nginx/nginx.template.conf
ENV NGINX_CGI_SERVER_HOST="127.0.0.1"
ENV NGINX_CGI_SERVER_PORT="9000"
ENV NGINX_ACCESS_LOG="/dev/stdout"
ENV NGINX_ERROR_LOG="/dev/stderr"
# debug|info|notice|warn|error|crit|alert|emerg (http://nginx.org/en/docs/ngx_core_module.html#error_log)
ENV NGINX_LOG_LEVEL="error"
ENV NGINX_WORKERS_COUNT="1"

# PHP configuration
COPY ./etc/php.ini /usr/local/etc/php/conf.d/zzz-php.ini
COPY ./etc/php-fpm.conf /usr/local/etc/php-fpm.d/zzz-php-fpm.conf
COPY ./etc/xdebug.ini /usr/local/etc/php/conf.d/zzz-xdebug.ini
# "/proc/self/fd/1" does not work for FPM_ACCESS_LOG
ENV FPM_ACCESS_LOG="/proc/self/fd/2"
ENV FPM_ERROR_LOG="/proc/self/fd/2"
# debug|notice|warning|error|alert (https://www.php.net/manual/en/install.fpm.configuration.php#log-level)
ENV FPM_LOG_LEVEL="error"
ENV FPM_WORKERS_COUNT="2"
ENV PHP_ERROR_LOG="/proc/self/fd/2"
# E_ALL|E_STRICT|E_NOTICE|E_WARNING|E_ERROR|E_CORE_ERROR (https://www.php.net/manual/en/errorfunc.constants.php)
ENV PHP_LOG_LEVEL="E_ERROR"
ENV PHP_OPCACHE_ENABLE="true"
ENV XDEBUG_MODE="off"
ENV XDEBUG_CONFIG=""
ENV XDEBUG_OUTPUT_DIR="/tmp"

# Image entrypoint
COPY ./bin/entrypoint.bash /usr/local/bin/entrypoint.bash
RUN chmod a+x /usr/local/bin/entrypoint.bash
ENTRYPOINT ["entrypoint.bash"]
CMD ["bash", "-c", "php-fpm --daemonize && nginx"]
