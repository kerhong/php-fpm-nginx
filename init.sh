#!/bin/ash

php-fpm5 --allow-to-run-as-root
nginx -g "daemon off;"
