FROM alpine:3.7

WORKDIR /srv/

RUN ( \
    apk add --no-cache supervisor curl \
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
  )

# We need to preload this separate libiconv for php iconv to work properly on alpine
RUN apk add --no-cache --repository http://dl-3.alpinelinux.org/alpine/edge/testing gnu-libiconv
ENV LD_PRELOAD /usr/lib/preloadable_libiconv.so

COPY php-fpm.conf php.ini /etc/php5/
COPY nginx.conf /etc/nginx/
COPY supervisor.ini /etc/supervisord/supervisor.ini

EXPOSE 80
CMD [ "/usr/bin/supervisord", "--nodaemon",  "--configuration", "/etc/supervisord/supervisor.ini"]
