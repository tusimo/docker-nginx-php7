FROM php:7.2-fpm-alpine

RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories

RUN apk update && apk upgrade

RUN apk add --no-cache curl \
        wget \
        git \
        vim \
        nginx \
        supervisor \
        nodejs 

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