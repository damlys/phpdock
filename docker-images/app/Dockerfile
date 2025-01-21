FROM ghcr.io/damlys/phpdock-sdk:0.0.0

COPY ./composer.json ./composer.lock /app/
RUN composer install \
  && composer clear-cache

COPY . /app
RUN composer run-script build \
  && chmod --recursive a+r /app \
  && chmod --recursive a+x /app/bin/* \
  && chown --recursive www-data:www-data /app/logs \
  && chmod --recursive a+w /app/logs
