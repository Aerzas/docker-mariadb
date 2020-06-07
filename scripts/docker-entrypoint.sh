#!/bin/sh
set -e

# Random root password
if [ -z "$MYSQL_ROOT_PASSWORD" ]; then
  mysql_root_password=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1)
  export MYSQL_ROOT_PASSWORD=${mysql_root_password}
fi

# Random user password
if [ -n "$MYSQL_USER" ] && [ -z "$MYSQL_USER_PASSWORD" ]; then
  mysql_user_password=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1)
  export MYSQL_USER_PASSWORD=${mysql_user_password}
fi

# Replace environment variables in template files
envs=$(printf '${%s} ' "$(sh -c \"env | cut -d'=' -f1\")")
find /etc/mysql -name '*.tmpl' \
  -exec sh -c 'filename="$1"; envsubst "${envs}" <"${filename}" >"${filename%?????}"' \
  -exec rm {} \;

sh /scripts/init-database.sh

exec "$@"
