FROM alpine:3.7

WORKDIR /srv/

RUN \
  apk add --no-cache \
    dumb-init curl nginx ffmpeg php5-fpm \
    php5-mcrypt php5-pdo php5-pdo_mysql php5-curl php5-openssl php5-xml php5-zip \
    php5-gd php5-json php5-phar php5-dom php5-bz2 php5-zlib php5-ctype php5-iconv \
  && ( \
    cd / \
    && curl -sS https://getcomposer.org/installer | /usr/bin/php5 \
    && /usr/bin/php5 /composer.phar selfupdate 1.3.2 \
  )

COPY php-fpm.conf php.ini /etc/php5/
COPY nginx.conf /etc/nginx/
COPY init.sh /

EXPOSE 80
CMD [ "dumb-init", "/init.sh" ]
