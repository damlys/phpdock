FROM ghcr.io/damlys/phpdock-rte:0.0.0

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
