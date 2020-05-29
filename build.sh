#!/bin/sh
set -e;

build_version="${1}";
build_mariadb_version="${2}";
if [ -z "${build_version}" ]; then
  echo 'Build version is required' >&2;
  exit 1;
fi;

registry_image='faering/mariadb';
declare -A mariadb_alpine_versions=(
  [10.4]=3.11.6
);
declare -A mariadb_versions=(
  [10.4]=10.4.13-r0
);

build_mariadb()
{
  mariadb_version="${1}";
  if [ -z "${mariadb_version}" ]; then
    echo 'Build MariaDB version is required' >&2;
    return 1;
  fi;
  if [ -z "${mariadb_versions[${mariadb_version}]}" ]; then
    echo 'Build MariaDB version is invalid' >&2;
    return 1;
  fi;

  echo -e "\e[32mBuild MariaDB image ${mariadb_version}\e[0m";

  # Build image
  docker build \
    --build-arg BUILD_ALPINE_TAG=${mariadb_alpine_versions[${mariadb_version}]} \
    --build-arg BUILD_MARIADB_PACKAGE_VERSION=${mariadb_versions[${mariadb_version}]} \
    -t ${registry_image}:${mariadb_version}-${build_version} \
    -f Dockerfile \
    . \
    --no-cache;

  # Push image
  docker push ${registry_image}:${mariadb_version}-${build_version};

  # Remove local image
  docker image rm ${registry_image}:${mariadb_version}-${build_version};
}

# Build single MariaDB version
if [ ! -z "${build_mariadb_version}" ]; then
  build_mariadb ${build_mariadb_version};
# Build all MariaDB versions
else
  for mariadb_version in "${!mariadb_versions[@]}"; do
    build_mariadb ${mariadb_version};
  done;
fi;
