FROM php:8.2-fpm-alpine AS php-base
RUN apk add --no-cache libxml2 oniguruma fcgi \
    && apk add --no-cache --virtual .build-deps $PHPIZE_DEPS libxml2-dev oniguruma-dev \
    && docker-php-ext-install -j$(nproc) pdo_mysql mbstring xml opcache \
    && apk del .build-deps
WORKDIR /var/www/html

FROM php-base AS dependencies
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer
COPY composer.json composer.lock ./
RUN composer install --no-dev --prefer-dist --no-interaction --no-progress --no-scripts --no-autoloader
COPY app ./app
COPY database ./database
RUN composer dump-autoload --no-dev --classmap-authoritative --no-scripts

FROM php-base AS runtime
ENV APP_ENV=production APP_DEBUG=false
COPY --chown=www-data:www-data app ./app
COPY --chown=www-data:www-data bootstrap ./bootstrap
COPY --chown=www-data:www-data config ./config
COPY --chown=www-data:www-data database ./database
COPY --chown=www-data:www-data public ./public
COPY --chown=www-data:www-data resources ./resources
COPY --chown=www-data:www-data routes ./routes
COPY --chown=www-data:www-data storage ./storage
COPY --chown=www-data:www-data artisan composer.json ./
COPY --from=dependencies --chown=www-data:www-data /var/www/html/vendor ./vendor
COPY docker/entrypoint.sh /usr/local/bin/app-entrypoint
COPY docker/php.ini /usr/local/etc/php/conf.d/production.ini
RUN chmod +x /usr/local/bin/app-entrypoint
USER www-data
EXPOSE 9000
ENTRYPOINT ["app-entrypoint"]
CMD ["php-fpm", "-F"]

FROM nginxinc/nginx-unprivileged:stable-alpine AS nginx
COPY docker/nginx.conf /etc/nginx/conf.d/default.conf
COPY public /var/www/html/public
EXPOSE 8000
