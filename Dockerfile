FROM php:8.0-fpm

# Start Composer installation
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer
# End Composer installation

# Start Project dependencies installation
RUN apt-get update -qq \
  && apt-get install -qq --no-install-recommends \
  git \
  zip \
  unzip \
  libzip-dev \
  && docker-php-ext-install \
  zip \
  && apt-get clean
# End Project dependencies installation

# Start mongodb installation
RUN pecl install mongodb
# RUN echo "extension=/usr/local/lib/php/extensions/no-debug-non-zts-20190902/mongodb.so" > /usr/local/etc/php/conf.d/mongo.ini
RUN docker-php-ext-enable mongodb
# Start creation of non-root user
ARG UID=1000
ARG GID=1000

RUN groupmod -g ${GID} www-data \
  && usermod -u ${UID} -g www-data www-data \
  && mkdir -p /var/app \
  && chown -hR www-data:www-data \
  /var/www \
  /var/app \
  /usr/local/

USER www-data:www-data
# End creation of non-root user

ADD . /var/app

WORKDIR /var/app
EXPOSE 8000