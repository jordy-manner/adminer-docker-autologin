FROM php:8.4-fpm

ARG ADMINER_VERSION="5.3.0"
ARG ADMINER_FLAVOUR=""

WORKDIR /var/www/html

RUN curl -L https://github.com/vrana/adminer/releases/download/v${ADMINER_VERSION}/adminer-${ADMINER_VERSION}${ADMINER_FLAVOUR}.php -o adminer.php

COPY /data/index.php /var/www/html/index.php
COPY /data/plugins/ /var/www/html/plugins/

EXPOSE 8080

CMD [ "php", "-S", "[::]:8080", "-t", "/var/www/html" ]