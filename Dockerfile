FROM php:7.2-fpm-alpine

RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories

RUN apk update && apk upgrade && \
    apk add --no-cache curl \
        wget \
        git \
        vim \
        nginx \
        supervisor \
        libpng-dev \
        libpq \
        icu-dev \
        libffi-dev \
        freetype-dev \
        libxslt-dev \
        libjpeg-turbo-dev \
        libwebp-dev \
        nodejs && \
    docker-php-ext-configure gd \
      --with-gd \
      --with-freetype-dir=/usr/include/ \
      --with-png-dir=/usr/include/ \
      --with-jpeg-dir=/usr/include/ \
      --with-webp-dir=/usr/include/ && \
    docker-php-ext-install pdo_mysql mysqli gd exif intl xsl soap zip opcache && \
    docker-php-source delete
    
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer \
    && composer config -g repo.packagist composer https://packagist.phpcomposer.com \
    && composer global require "hirak/prestissimo:^0.3"

RUN npm install -g cnpm gulp bower yarn --registry=https://registry.npm.taobao.org \
    && yarn config set registry https://registry.npm.taobao.org

RUN mkdir -p /run/nginx

ENV PATH=$PATH:~/.composer/vendor/bin

COPY conf/ /etc

WORKDIR /var/www/html

EXPOSE 80 443

CMD ["supervisord", "-n", "-c", "/etc/supervisord.conf"]
