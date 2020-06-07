#!/bin/sh
set -e

host=$(hostname -i || echo '127.0.0.1')
user="${MYSQL_USER:-root}"
password="${MYSQL_USER_PASSWORD:-$MYSQL_ROOT_PASSWORD}"

if select=$(echo 'SELECT 1' | mysql -h"${host}" -u"${user}" -p"${password}" --silent) && [ "${select}" = '1' ]; then
  exit 0
fi

exit 1
