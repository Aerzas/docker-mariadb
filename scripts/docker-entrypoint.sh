#!/bin/sh
set -e;

# Random root password
if [ -z "$MYSQL_ROOT_PASSWORD" ]; then
    export MYSQL_ROOT_PASSWORD=`cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1`;
fi;

# Random user password
if [ ! -z "$MYSQL_USER" -a -z "$MYSQL_USER_PASSWORD" ]; then
    export MYSQL_USER_PASSWORD=`cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1`;
fi;

# Replace environment variables in template files
envs=`printf '${%s} ' $(sh -c "env|cut -d'=' -f1")`;
for filename in $(find /etc/mysql -name '*.tmpl'); do
    envsubst "$envs" < "$filename" > ${filename:0:$((${#filename}-5))};
    rm "$filename";
done

sh /scripts/init-database.sh;

exec "$@"
