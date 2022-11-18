#!/usr/bin/env bash

# https://documentation.its.umich.edu/node/2118
if [ "$(id -u)" -ge 1000 ]; then
  sed -e "/^www-data:/c www-data:x:$(id -u):$(id -g):www-data:/var/www:/usr/sbin/nologin" /etc/passwd >/tmp/passwd
  cat /tmp/passwd >/etc/passwd
  rm /tmp/passwd
fi

# set default values, in case they weren't specified
FASTCGI_READ_TIMEOUT="${FASTCGI_READ_TIMEOUT=180}"
NGINX_ACCESS_LOG="${NGINX_ACCESS_LOG=/var/log/nginx/project_access.log}"
NGINX_ERROR_LOG="${NGINX_ERROR_LOG=/var/log/nginx/project_error.log}"

# substitute values into config files
sed -i \
  -e "s|\(fastcgi_read_timeout\).*;|\1 ${FASTCGI_READ_TIMEOUT};|" \
  -e "s|\(access_log\).*;|\1 ${NGINX_ACCESS_LOG};|" \
  -e "s|\(error_log\).*;|\1 ${NGINX_ERROR_LOG};|" \
  /etc/nginx/sites-available/default

sed -i \
  -e "s|\(access_log\).*;|\1 ${NGINX_ACCESS_LOG};|" \
  -e "s|\(error_log\).*;|\1 ${NGINX_ERROR_LOG};|" \
  -e 's|/run/nginx.pid|/tmp/nginx.pid|g' \
  -e '/^user/d' \
  /etc/nginx/nginx.conf

if [ "${RUN_MIGRATIONS}" = true ]; then
  # Run migrations
  echo 'Checking for DB readiness...'
  while ! php bin/console dbal:run-sql 'SELECT version()' >/dev/null 2>&1; do
    echo 'Waiting 1 second for DB to become ready...'
    sleep 1 # wait 1 second before checking again
  done
  echo 'DB ready.'
  php bin/console doctrine:migrations:migrate --no-interaction
fi
