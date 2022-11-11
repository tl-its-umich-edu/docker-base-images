#!/usr/bin/env bash

# https://documentation.its.umich.edu/node/2118
if [ "$(id -u)" -ge 1000 ] ; then
    sed -e "/^www-data:/c www-data:x:$(id -u):$(id -g):www-data:/var/www:/usr/sbin/nologin" /etc/passwd > /tmp/passwd
    cat /tmp/passwd > /etc/passwd
    rm /tmp/passwd
fi

if [ "${RUN_MIGRATIONS}" = true ] ; then
    # Run migrations
    echo "Waiting for DB"
    while ! php bin/console dbal:run-sql 'SELECT version()' > /dev/null 2>&1; do   
        echo "Waiting 1 second for database to be available."
        sleep 1 # wait 1 second before check again
    done
    php bin/console doctrine:migrations:migrate --no-interaction
fi
