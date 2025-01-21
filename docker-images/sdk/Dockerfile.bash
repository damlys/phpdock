#!/bin/bash
set -ex

apt-get update

# install Composer bash completion
apt-get install --yes --no-install-recommends bash-completion
echo ". /etc/bash_completion" >>~/.bashrc
composer global require bamarni/symfony-console-autocomplete
echo "$(php ~/.composer/vendor/bin/symfony-autocomplete --shell bash composer)" >/etc/bash_completion.d/composer

# install Xdebug
pecl install xdebug
docker-php-ext-enable xdebug

# cleanup
apt-get clean && rm -rf /var/lib/apt/lists/*
pecl clear-cache
composer clear-cache
rm -rf /tmp/*
