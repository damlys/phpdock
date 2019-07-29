FROM 127.0.0.1:5000/phpdock/php-web-server-foundation:0.0.1-example

COPY app/composer.json app/composer.lock /app/
RUN composer install --no-dev \
&& composer clear-cache

ENV TESTER_TARGET_ENTRYPOINT="http://127.0.0.1:80"

COPY app /app
RUN composer run-script build \
&& chmod --recursive a+r /app \
&& chmod --recursive a+w /app/xdebug
