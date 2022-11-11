#!/usr/bin/env bash

# https://documentation.its.umich.edu/node/2118
if [ "$(id -u)" -ge 1000 ]; then
  sed -e "/^www-data:/c www-data:x:$(id -u):$(id -g):www-data:/var/www:/usr/sbin/nologin" /etc/passwd >/tmp/passwd
  cat /tmp/passwd >/etc/passwd
  rm /tmp/passwd
fi

sed -i -e "s/\(fastcgi_read_timeout\) 180;/\1 ${FASTCGI_READ_TIMEOUT=180};/" \
  /etc/nginx/sites-available/default

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
