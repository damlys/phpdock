FROM damlys/phpdock-rte:latest

ENV VERSION="0.0.9"
COPY ./app/composer.json ./app/composer.lock /app/
RUN composer install \
&& composer clear-cache

COPY ./app /app
RUN composer run-script build \
&& chmod --recursive a+r /app \
&& chmod --recursive a+x /app/bin/* \
&& chown --recursive 1000:1000 /app/logs \
&& chmod --recursive a+w /app/logs
