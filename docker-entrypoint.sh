#!/bin/bash
set -e

unset IFS
args=()
i=0

IGNORED1=("REDIS_DOWNLOAD_SHA" "REDIS_DOWNLOAD_URL" "REDIS_VERSION")

for var in $(compgen -e); do
  if [[ $var == REDIS_* ]]; then
    if ! [[ ${IGNORED1[*]} =~ "$var" ]]; then
      param=$(echo "${var#REDIS_}" | tr '[:upper:]' '[:lower:]' | tr _ -);
      if ! [[ ${IGNORED2[*]} =~ "$param" ]]; then
        echo "$param" "${!var}" >> /etc/redis/redis.conf
      fi
    fi
  fi
done

if [ "$*" = "start" ];then
  exec gosu redis redis-server /etc/redis/redis.conf
elif [ "$*" = "check" ];then
  echo -e "\033[0;32mRedis configuration at /etc/redis/redis.conf \033[0m";
  cat /etc/redis/redis.conf | sort
  echo -e "\033[0;32m--------------------------------------------\033[0m";
else
    exec "$@"
fi


#
## first arg is `-f` or `--some-option`
## or first arg is `something.conf`
#if [ "${1#-}" != "$1" ] || [ "${1%.conf}" != "$1" ]; then
#	set -- redis-server "$@"
#fi
#
## allow the container to be started with `--user`
#if [ "$1" = 'redis-server' -a "$(id -u)" = '0' ]; then
#	find . \! -user redis -exec chown redis '{}' +
#	exec gosu redis "$0" "$@"
#fi
#exec "$@"
