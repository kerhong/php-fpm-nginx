FROM alpine:3.7

RUN apk add --no-cache \
    supervisor ffmpeg curl wget nginx php5-fpm \
    php5-mcrypt php5-pdo php5-pdo_mysql php5-curl php5-openssl php5-xml php5-zip \
    php5-gd php5-json php5-phar php5-dom php5-bz2 php5-zlib php5-ctype php5-iconv \
  && apk add --no-cache --repository http://dl-3.alpinelinux.org/alpine/edge/testing gnu-libiconv \
  && cd / && curl -sS https://getcomposer.org/installer | /usr/bin/php5 && /usr/bin/php5 /composer.phar selfupdate 1.3.2 \
  && apk add --no-cache nodejs ca-certificates openssl \
  && npm install -g npm@3.10.3 \
  && wget -qO- "https://github.com/dustinblackman/phantomized/releases/download/2.1.1/dockerized-phantomjs.tar.gz" | tar xz -C / \
  && npm install -g phantomjs-prebuilt

ENV PHANTOMJS_BINARY /usr/bin/phantomjs
ENV LD_PRELOAD /usr/lib/preloadable_libiconv.so

COPY php-fpm.conf php.ini /etc/php5/
COPY nginx.conf /etc/nginx/
COPY supervisor.ini /etc/supervisord/supervisor.ini

WORKDIR /srv/
EXPOSE 80
CMD [ "/usr/bin/supervisord", "--nodaemon",  "--configuration", "/etc/supervisord/supervisor.ini"]
