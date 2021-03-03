FROM 127.0.0.1:5000/phpdock/base-image:0.0.0

COPY ./app/composer.json ./app/composer.lock /app/
RUN composer install --no-dev \
&& composer clear-cache

COPY ./app /app
RUN composer run-script build \
&& chmod --recursive a+r /app \
&& chmod --recursive a+x /app/bin/* \
&& chown --recursive 1000:1000 /app/logs \
&& chmod --recursive a+w /app/logs \
&& chown --recursive 1000:1000 /app/xdebug \
&& chmod --recursive a+w /app/xdebug
