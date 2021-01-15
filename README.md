# saxix-redis

Docker images based on official Redis Alpine with ability to configure the server using environment variables.
Any known Redis setting can be passed via env using `REDIS_setting` name using underscores `_` instead of dashes `-`,
each variables will be added to the `/etc/redis/redis.conf` as follow.

    REDIS_MAXMEMORY -> maxmemory
    REDIS_maxmemory_policy -> maxmemory-policy
    REDIS_pidfile -> pidfile
    
In case you find any issue you can check the configuration with:

    docker run \
            --rm \
            -e REDIS_loglevel=warning \
            -e REDIS_maxmemory=1G \
            saxix/redis:6.0.10 \
            check
display:

    Redis configuration at /etc/redis/redis.conf
    daemonize no
    logfile ''
    loglevel warning    
    maxmemory 1G
    maxmemory-policy noeviction
    pidfile /var/run/redis_6379.pid
    --------------------------------------------

### How to use this image
#### start a redis instance
    
    $ docker run --name some-redis -d saxix/redis

#### start with persistent storage
    $ docker run --name some-redis -e REDIS_appendonly=yes -d redis 

If persistence is enabled, data is stored in the `VOLUME /data`, which can be used with --volumes-from some-volume-container or -v /docker/host/dir:/data (see docs.docker volumes).

For more about Redis Persistence, see http://redis.io/topics/persistence.

