FROM damlys/phpdock-rte-sdk:0.0.0

ENV VERSION="0.0.5"
COPY ./app/composer.json ./app/composer.lock /app/
RUN composer install --no-dev --no-scripts \
&& composer clear-cache

COPY ./app /app
RUN composer run-script build \
&& chmod --recursive a+r /app \
&& chmod --recursive a+x /app/bin/* \
&& chown --recursive 1000:1000 /app/logs \
&& chmod --recursive a+w /app/logs
