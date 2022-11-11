#!/usr/bin/env bash
/etc/pre-start.sh

service nginx start
php-fpm
