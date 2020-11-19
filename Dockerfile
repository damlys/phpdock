FROM 127.0.0.1:5000/phpdock/base-image:0.0.0

COPY ./app/composer.json ./app/composer.lock /app/
RUN composer install --no-dev \
&& composer clear-cache

ENV APP_DEFAULT_CHARSET="UTF-8"
ENV APP_DEFAULT_LOCALE="en-US"
ENV APP_DEFAULT_TIMEZONE="UTC"
ENV APP_ENV="production"
ENV APP_TESTS_TARGET_ENTRYPOINT="http://127.0.0.1:8080"

COPY ./app /app
RUN composer run-script build \
&& chmod --recursive a+r /app \
&& chmod --recursive a+x /app/bin/* \
&& chmod --recursive a+w /app/xdebug
