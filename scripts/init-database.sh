#!/bin/sh
set -eo

if [ ! -d '/var/lib/mysql/mysql' ]; then
  # Initialize database
  mysql_install_db --auth-root-authentication-method=normal

  # Set root password
  echo "ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';" >"${MARIABD_INIT_FILE}"

  # Drop the anonymous and scoped users
  {
    echo "DROP USER ''@'localhost';"
    echo "DROP USER ''@'$(hostname)';"
    echo "DROP USER 'root'@'$(hostname)';"
  } >>"${MARIABD_INIT_FILE}"

  # Remove test database
  {
    echo "DROP DATABASE test;"
    echo "DELETE FROM mysql.db WHERE Db='test' OR Db='test\_%';"
  } >>"${MARIABD_INIT_FILE}"

  # Create database
  if [ -n "${MYSQL_DATABASE}" ]; then
    echo "CREATE DATABASE IF NOT EXISTS \`${MYSQL_DATABASE}\`;" >>"${MARIABD_INIT_FILE}"
  fi

  # Create user
  if [ -n "${MYSQL_USER}" ] && [ -n "${MYSQL_USER_PASSWORD}" ]; then
    echo "CREATE USER '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_USER_PASSWORD}';" >>"${MARIABD_INIT_FILE}"

    if [ -n "${MYSQL_DATABASE}" ]; then
      echo "GRANT ALL ON \`${MYSQL_DATABASE}\`.* TO '${MYSQL_USER}'@'%';" >>"${MARIABD_INIT_FILE}"
    fi
  fi

  # Apply changes
  echo "FLUSH PRIVILEGES;" >>"${MARIABD_INIT_FILE}"
fi
