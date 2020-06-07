#!/bin/sh
set -e

build_version="${1}"
build_mariadb_version="${2}"
if [ -z "${build_version}" ]; then
  echo 'Build version is required' >&2
  exit 1
fi

registry_image='faering/mariadb'

mariadb_alpine_tag() {
  mariadb_version="${1}"
  if [ -z "${mariadb_version}" ]; then
    echo 'MariaDB version is required' >&2
    return 1
  fi

  case ${mariadb_version} in
  10.4)
    echo 3.11.6
    ;;
  *)
    return 0
    ;;
  esac
}

mariadb_package_version() {
  mariadb_version="${1}"
  if [ -z "${mariadb_version}" ]; then
    echo 'MariaDB version is required' >&2
    return 1
  fi

  case ${mariadb_version} in
  10.4)
    echo 10.4.13-r0
    ;;
  *)
    return 0
    ;;
  esac
}

build_mariadb() {
  mariadb_version="${1}"
  if [ -z "${mariadb_version}" ]; then
    echo 'Build MariaDB version is required' >&2
    return 1
  fi
  if [ -z "$(mariadb_package_version ${mariadb_version})" ]; then
    echo 'Build MariaDB version is invalid' >&2
    return 1
  fi

  echo "$(printf '\033[32m')Build MariaDB image ${mariadb_version}$(printf '\033[m')"

  # Build image
  docker build \
    --build-arg BUILD_ALPINE_TAG="$(mariadb_alpine_tag ${mariadb_version})" \
    --build-arg BUILD_MARIADB_PACKAGE_VERSION="$(mariadb_package_version ${mariadb_version})" \
    -t "${registry_image}:${mariadb_version}-${build_version}" \
    -f Dockerfile \
    . \
    --no-cache

  # Push image
  docker push "${registry_image}:${mariadb_version}-${build_version}"

  # Remove local image
  docker image rm "${registry_image}:${mariadb_version}-${build_version}"
}

# Build single MariaDB version
if [ -n "${build_mariadb_version}" ]; then
  build_mariadb "${build_mariadb_version}"
# Build all MariaDB versions
else
  build_mariadb 10.4
fi
