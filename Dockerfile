FROM redis:6.0.10-alpine

RUN apk update \
    && apk upgrade

RUN apk add --no-cache --virtual .run-deps \
        --repository http://dl-cdn.alpinelinux.org/alpine/edge/main \
        --repository http://dl-cdn.alpinelinux.org/alpine/edge/testing \
        bash \
        gosu

COPY docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
COPY redis.conf /etc/redis/redis.default.conf
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

ENV REDIS_MAXMEMORY "0"
ENV REDIS_loglevel "notice"
ENV REDIS_logfile "''"
ENV REDIS_daemonize "no"
ENV REDIS_maxmemory_policy noeviction
ENV REDIS_pidfile /var/run/redis_6379.pid

ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["start"]
