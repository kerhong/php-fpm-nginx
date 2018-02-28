FROM alpine:3.7

WORKDIR /srv/

RUN ( \
    apk add --no-cache dumb-init curl \
  ) && ( \
    apk add --no-cache nginx \
  ) && ( \
    apk add --no-cache php5-fpm ffmpeg \
      php5-mcrypt php5-pdo php5-pdo_mysql php5-curl php5-openssl php5-xml php5-zip \
      php5-gd php5-json php5-phar php5-dom php5-bz2 php5-zlib php5-ctype php5-iconv \
  ) && ( \
    cd / \
    && curl -sS https://getcomposer.org/installer | /usr/bin/php5 \
    && /usr/bin/php5 /composer.phar selfupdate 1.3.2 \
  ) && ( \
    apk add --no-cache nodejs \
    && npm install -g npm@3.10.3 \
    && apk add --no-cache --virtual .phantom-build-deps ca-certificates openssl \
    && wget -qO- "https://github.com/dustinblackman/phantomized/releases/download/2.1.1/dockerized-phantomjs.tar.gz" | tar xz -C / \
    && npm install -g phantomjs-prebuilt \
    && apk del .phantom-build-deps \
  )

ENV PHANTOMJS_BINARY /usr/lib/node_modules/phantomjs-prebuilt/lib/phantom/bin/phantomjs

COPY php-fpm.conf php.ini /etc/php5/
COPY nginx.conf /etc/nginx/
COPY init.sh /

EXPOSE 80
CMD [ "dumb-init", "/init.sh" ]
