FROM php:8.4-fpm
# $ cat /etc/passwd | grep 'www-data'
# www-data:x:33:33:www-data:/var/www:/usr/sbin/nologin
# $ cat /etc/group | grep 'www-data'
# www-data:x:33:

COPY ./Dockerfile.bash /Dockerfile.bash
RUN /Dockerfile.bash && rm /Dockerfile.bash

# Nginx configuration
COPY ./etc/nginx.conf /etc/nginx/nginx.conf
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
ENTRYPOINT []
CMD ["bash", "-c", "php-fpm --daemonize && nginx"]
EXPOSE 8080 9000
HEALTHCHECK NONE
WORKDIR /app
