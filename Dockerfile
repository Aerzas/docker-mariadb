ARG BUILD_ALPINE_IMAGE

FROM ${BUILD_ALPINE_IMAGE}

ENV MARIADB_DATA_DIR="/var/lib/mysql" \
    MARIABD_INIT_FILE="/tmp/mysqld-init"

ARG BUILD_MARIADB_PACKAGE_VERSION

RUN set -ex; \
    # Install MariaDB
    apk add --update --no-cache mariadb=${BUILD_MARIADB_PACKAGE_VERSION}; \
    # Remove dev, test, doc, benchmark related files
    rm -rf \
        /usr/bin/mysql_client_test \
        /usr/bin/mysql_client_test_embedded \
        /usr/bin/mysql_config \
        /usr/bin/mysqltest \
        /usr/bin/mysqltest_embedded \
        /usr/include/mysql \
        /usr/lib/libmariadb.so* \
        /usr/lib/libmariadbd.so.* \
        /usr/lib/libmysqlclient.so* \
        /usr/lib/libmysqlclient_r.so* \
        /usr/lib/libmysqld.so.* \
        /usr/mysql-test \
        /usr/share/man \
        /usr/sql-bench; \
    # Install mysql client
    apk add --no-cache --virtual .mariadb-client mariadb-client; \
    cp /usr/bin/mysql /usr/local/bin/mysql; \
    apk del .mariadb-client; \
    # Install envsubst
    apk add --update libintl; \
    apk add --no-cache --virtual .gettext gettext; \
    cp /usr/bin/envsubst /usr/local/bin/envsubst; \
    apk del .gettext; \
    # Prepare base folders
    mkdir -p ${MARIADB_DATA_DIR} \
        /etc/mysql \
        /etc/mysql/my.cnf.d/ \
        /var/mysql \
        /var/run/mysqld \
        /usr/lib/mysql/plugin; \
    # Execute mariadb as any user
    chgrp -R 0 ${MARIADB_DATA_DIR} \
        /etc/mysql \
        /etc/mysql/my.cnf.d/ \
        /var/mysql \
        /var/run/mysqld \
        /usr/lib/mysql/plugin; \
    chmod -R g+rwX ${MARIADB_DATA_DIR} \
        /etc/mysql \
        /etc/mysql/my.cnf.d/ \
        /var/mysql \
        /var/run/mysqld \
        /usr/lib/mysql/plugin; \
    # Cleanup
    rm -rf /tmp/* \
        /var/cache/apk/*; \
    # Initializing script
    touch ${MARIABD_INIT_FILE}; \
    chgrp 0 ${MARIABD_INIT_FILE}; \
    chmod g+rwX ${MARIABD_INIT_FILE}

ENV MARIADB_SSL_CA='' \
    MARIADB_SSL_CERT='' \
    MARIADB_SSL_KEY='' \
    MARIADB_TLS_VERSION='TLSv1.2,TLSv1.3' \
    MYSQL_BACK_LOG=100 \
    MYSQL_CHARACTER_SET_FILESYSTEM=utf8mb4 \
    MYSQL_CHARACTER_SET_SERVER=utf8mb4 \
    MYSQL_CLIENT_DEFAULT_CHARACTER_SET=utf8mb4 \
    MYSQL_COLLATION_SERVER=utf8mb4_unicode_ci \
    MYSQL_CONNECT_TIMEOUT=10 \
    MYSQL_DATABASE='' \
    MYSQL_DEFAULT_STORAGE_ENGINE=InnoDB \
    MYSQL_DUMP_MAX_ALLOWED_PACKET=1G \
    MYSQL_GENERAL_LOG=0 \
    MYSQL_INIT_CONNECT='SET NAMES utf8mb4' \
    MYSQL_INNODB_BUFFER_POOL_INSTANCES=1 \
    MYSQL_INNODB_BUFFER_POOL_SIZE=128M \
    MYSQL_INNODB_DATA_FILE_PATH=ibdata1:10M:autoextend:max:10G \
    MYSQL_INNODB_DEFAULT_ROW_FORMAT=dynamic \
    MYSQL_INNODB_FAST_SHUTDOWN=1 \
    MYSQL_INNODB_FILE_PER_TABLE=1 \
    MYSQL_INNODB_FLUSH_LOG_AT_TRX_COMMIT=2 \
    MYSQL_INNODB_FLUSH_METHOD=O_DIRECT \
    MYSQL_INNODB_FORCE_LOAD_CORRUPTED=0 \
    MYSQL_INNODB_FORCE_RECOVERY=0 \
    MYSQL_INNODB_IO_CAPACITY=200 \
    MYSQL_INNODB_LOCK_WAIT_TIMEOUT=50 \
    MYSQL_INNODB_LOG_BUFFER_SIZE=8M \
    MYSQL_INNODB_LOG_FILE_SIZE=128M \
    MYSQL_INNODB_LOG_FILES_IN_GROUP=2 \
    MYSQL_INNODB_OLD_BLOCKS_TIME=1000 \
    MYSQL_INNODB_OPEN_FILES=1024 \
    MYSQL_INNODB_PURGE_THREADS=4 \
    MYSQL_INNODB_READ_IO_THREADS=4 \
    MYSQL_INNODB_STATS_ON_METADATA=OFF \
    MYSQL_INNODB_STRICT_MODE=OFF \
    MYSQL_INNODB_WRITE_IO_THREADS=4 \
    MYSQL_INTERACTIVE_TIMEOUT=420 \
    MYSQL_JOIN_BUFFER_SIZE=8M \
    MYSQL_LOG_WARNINGS=2 \
    MYSQL_LONG_QUERY_TIME=2 \
    MYSQL_MAX_ALLOWED_PACKET=256M \
    MYSQL_MAX_CONNECT_ERRORS=100000 \
    MYSQL_MAX_CONNECTIONS=100 \
    MYSQL_MAX_HEAP_TABLE_SIZE=16M \
    MYSQL_NET_READ_TIMEOUT=90 \
    MYSQL_NET_WRITE_TIMEOUT=90 \
    MYSQL_OPTIMIZER_PRUNE_LEVEL=1 \
    MYSQL_OPTIMIZER_SEARCH_DEPTH=62 \
    MYSQL_PERFORMANCE_SCHEMA=OFF \
    MYSQL_QUERY_CACHE_LIMIT=1M \
    MYSQL_QUERY_CACHE_MIN_RES_UNIT=4K \
    MYSQL_QUERY_CACHE_SIZE=128M \
    MYSQL_QUERY_CACHE_TYPE=ON \
    MYSQL_RELAY_LOG_RECOVERY=0 \
    MYSQL_ROOT_PASSWORD='' \
    MYSQL_SLOW_QUERY_LOG=OFF \
    MYSQL_SORT_BUFFER_SIZE=2M \
    MYSQL_TABLE_DEFINITION_CACHE=400 \
    MYSQL_TABLE_OPEN_CACHE=4096 \
    MYSQL_THREAD_CACHE_SIZE=75 \
    MYSQL_TMP_TABLE_SIZE=16M \
    MYSQL_USER='' \
    MYSQL_USER_PASSWORD='' \
    MYSQL_WAIT_TIMEOUT=420

USER 1001

COPY conf/my.cnf.tmpl /etc/mysql/
COPY conf/my.cnf.d/* /etc/mysql/my.cnf.d/
COPY scripts/*.sh /scripts/

WORKDIR ${MARIADB_DATA_DIR}
VOLUME ${MARIADB_DATA_DIR}

EXPOSE 3306

STOPSIGNAL SIGTERM

ENTRYPOINT ["/scripts/docker-entrypoint.sh"]
CMD ["mysqld", "--init-file=/tmp/mysqld-init"]
