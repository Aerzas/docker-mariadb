#!/bin/sh
set -eo pipefail;

if [ ! -d '/var/lib/mysql/mysql' ]; then
    # Initialize database
    mysql_install_db --auth-root-authentication-method=normal;

    # Set root password
    echo "UPDATE mysql.user SET Password = PASSWORD('$MYSQL_ROOT_PASSWORD') WHERE User = 'root';" > /tmp/mysqld-init;

    # Drop the anonymous and scoped users
    echo "DROP USER ''@'localhost';" >> /tmp/mysqld-init;
    echo "DROP USER ''@'$(hostname)';" >> /tmp/mysqld-init;
    echo "DROP USER 'root'@'$(hostname)';" >> /tmp/mysqld-init;

    # Remove test database
    echo "DROP DATABASE test;" >> /tmp/mysqld-init;
    echo "DELETE FROM mysql.db WHERE Db='test' OR Db='test\_%';" >> /tmp/mysqld-init;

    # Create database
    if [ ! -z "$MYSQL_DATABASE" ]; then
        echo "CREATE DATABASE IF NOT EXISTS \`$MYSQL_DATABASE\`;" >> /tmp/mysqld-init;
    fi;

    # Create user
    if [ ! -z "$MYSQL_USER" -a ! -z "$MYSQL_USER_PASSWORD" ]; then
        echo "CREATE USER '$MYSQL_USER'@'%' IDENTIFIED BY '$MYSQL_USER_PASSWORD';" >> /tmp/mysqld-init;

        if [ ! -z "$MYSQL_DATABASE" ]; then
            echo "GRANT ALL ON \`$MYSQL_DATABASE\`.* TO '$MYSQL_USER'@'%';" >> /tmp/mysqld-init;
        fi;
    fi;

    # Apply changes
    echo "FLUSH PRIVILEGES;" >> /tmp/mysqld-init;
fi;
