FROM php:8.4-fpm

ARG ADMINER_VERSION="5.3.0"
ARG ADMINER_FLAVOUR=""

# Cleaning
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# Install system dependencies
ADD --chmod=0755 https://github.com/mlocati/docker-php-extension-installer/releases/latest/download/install-php-extensions /usr/local/bin/
RUN install-php-extensions mysqli pdo_dblib pdo_mysql pdo_sqlsrv pgsql sqlsrv

WORKDIR /var/www/html

RUN curl -L https://github.com/vrana/adminer/releases/download/v${ADMINER_VERSION}/adminer-${ADMINER_VERSION}${ADMINER_FLAVOUR}.php -o adminer.php

COPY /data/index.php /var/www/html/index.php
COPY /data/plugins/ /var/www/html/plugins/

EXPOSE 8080

CMD [ "php", "-S", "[::]:8080", "-t", "/var/www/html" ]