# MariaDB

MariaDB docker container image that requires no specific user or root permission to function.

Docker Hub image: [https://hub.docker.com/r/aerzas/mariadb](https://hub.docker.com/r/aerzas/mariadb)

## Docker compose example

```yaml
version: '3.5'
services:
    php:
        image: aerzas/mariadb:10.11-latest
        environment:
            MYSQL_DATABASE: sampledb
            MYSQL_ROOT_PASSWORD: 3x@mplE
            MYSQL_USER: sampledb
            MYSQL_USER_PASSWORD: sampledb
        ports:
            - '3306:3306'
        volumes:
            - database:/var/lib/mysql
        healthcheck:
            test: ["CMD", "/scripts/docker-healthcheck.sh"]
            interval: 30s
            timeout: 1s
            retries: 3
            start_period: 30s
volumes:
  database:
```

Additional configuration files can be mounted in `/etc/mysql/my.cnf.d/`, files mounted as `.tmpl` will have their
environment variables automatically replaced.

Database can be made persistent by either declaring a named volume or mounting a folder. If no database exists, one
will be initialized with the given `MYSQL_DATABASE`, `MYSQL_ROOT_PASSWORD`, `MYSQL_USER` and `MYSQL_USER_PASSWORD`
parameters. If no password is provided, one will be generated.

## Environment Variables

| Variable                               | Default Value                    |
|----------------------------------------|----------------------------------|
| **client**                             |                                  |
| `MYSQL_CLIENT_DEFAULT_CHARACTER_SET`   | `utf8mb4`                        |
| **database**                           |                                  |
| `MYSQL_DATABASE`                       |                                  |
| `MYSQL_ROOT_PASSWORD`                  |                                  |
| `MYSQL_USER`                           |                                  |
| `MYSQL_USER_PASSWORD`                  |                                  |
| **mariadb**                            |                                  |
| `MARIADB_TLS_VERSION`                  | `TLSv1.2,TLSv1.3`                |
| `MARIADB_SSL_CERT`                     |                                  |
| `MARIADB_SSL_KEY`                      |                                  |
| `MARIADB_SSL_CA`                       |                                  |
| **mysqld**                             |                                  |
| `MYSQL_BACK_LOG`                       | `100`                            |
| `MYSQL_CHARACTER_SET_FILESYSTEM`       | `utf8mb4`                        |
| `MYSQL_CHARACTER_SET_SERVER`           | `utf8mb4`                        |
| `MYSQL_COLLATION_SERVER`               | `utf8mb4_unicode_ci`             |
| `MYSQL_CONNECT_TIMEOUT`                | `10`                             |
| `MYSQL_DEFAULT_STORAGE_ENGINE`         | `InnoDB`                         |
| `MYSQL_GENERAL_LOG`                    | `0`                              |
| `MYSQL_INIT_CONNECT`                   | `SET NAMES utf8mb4`              |
| `MYSQL_INNODB_BUFFER_POOL_INSTANCES`   | `1`                              |
| `MYSQL_INNODB_BUFFER_POOL_SIZE`        | `128M`                           |
| `MYSQL_INNODB_DATA_FILE_PATH`          | `ibdata1:12M:autoextend:max:10G` |
| `MYSQL_INNODB_DEFAULT_ROW_FORMAT`      | `dynamic`                        |
| `MYSQL_INNODB_FAST_SHUTDOWN`           | `1`                              |
| `MYSQL_INNODB_FILE_PER_TABLE`          | `1`                              |
| `MYSQL_INNODB_FLUSH_LOG_AT_TRX_COMMIT` | `2`                              |
| `MYSQL_INNODB_FLUSH_METHOD`            | `O_DIRECT`                       |
| `MYSQL_INNODB_FORCE_LOAD_CORRUPTED`    | `0`                              |
| `MYSQL_INNODB_FORCE_RECOVERY`          | `0`                              |
| `MYSQL_INNODB_IO_CAPACITY`             | `200`                            |
| `MYSQL_INNODB_LOCK_WAIT_TIMEOUT`       | `50`                             |
| `MYSQL_INNODB_LOG_BUFFER_SIZE`         | `8M`                             |
| `MYSQL_INNODB_LOG_FILE_SIZE`           | `128M`                           |
| `MYSQL_INNODB_LOG_FILES_IN_GROUP`      | `2`                              |
| `MYSQL_INNODB_OLD_BLOCKS_TIME`         | `1000`                           |
| `MYSQL_INNODB_OPEN_FILES`              | `1024`                           |
| `MYSQL_INNODB_PURGE_THREADS`           | `4`                              |
| `MYSQL_INNODB_READ_IO_THREADS`         | `4`                              |
| `MYSQL_INNODB_STATS_ON_METADATA`       | `OFF`                            |
| `MYSQL_INNODB_STRICT_MODE`             | `OFF`                            |
| `MYSQL_INNODB_WRITE_IO_THREADS`        | `4`                              |
| `MYSQL_INTERACTIVE_TIMEOUT`            | `420`                            |
| `MYSQL_JOIN_BUFFER_SIZE`               | `8M`                             |
| `MYSQL_LOG_WARNINGS`                   | `2`                              |
| `MYSQL_LONG_QUERY_TIME`                | `2`                              |
| `MYSQL_MAX_ALLOWED_PACKET`             | `256M`                           |
| `MYSQL_MAX_CONNECT_ERRORS`             | `100000`                         |
| `MYSQL_MAX_CONNECTIONS`                | `100`                            |
| `MYSQL_MAX_HEAP_TABLE_SIZE`            | `16M`                            |
| `MYSQL_NET_READ_TIMEOUT`               | `90`                             |
| `MYSQL_NET_WRITE_TIMEOUT`              | `90`                             |
| `MYSQL_OPTIMIZER_PRUNE_LEVEL`          | `1`                              |
| `MYSQL_OPTIMIZER_SEARCH_DEPTH`         | `62`                             |
| `MYSQL_PERFORMANCE_SCHEMA`             | `OFF`                            |
| `MYSQL_QUERY_CACHE_LIMIT`              | `1M`                             |
| `MYSQL_QUERY_CACHE_MIN_RES_UNIT`       | `4K`                             |
| `MYSQL_QUERY_CACHE_SIZE`               | `128M`                           |
| `MYSQL_QUERY_CACHE_TYPE`               | `ON`                             |
| `MYSQL_RELAY_LOG_RECOVERY`             | `0`                              |
| `MYSQL_SLOW_QUERY_LOG`                 | `OFF`                            |
| `MYSQL_SORT_BUFFER_SIZE`               | `2M`                             |
| `MYSQL_TABLE_DEFINITION_CACHE`         | `400`                            |
| `MYSQL_TABLE_OPEN_CACHE`               | `4096`                           |
| `MYSQL_THREAD_CACHE_SIZE`              | `75`                             |
| `MYSQL_TMP_TABLE_SIZE`                 | `16M`                            |
| `MYSQL_WAIT_TIMEOUT`                   | `420`                            |
| **mysqldump**                          |                                  |
| `MYSQL_DUMP_MAX_ALLOWED_PACKET`        | `1G`                             |
