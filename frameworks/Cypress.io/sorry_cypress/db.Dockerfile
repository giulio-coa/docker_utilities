FROM mongo:latest

RUN apt-get update; apt-get upgrade; apt-get install --assume-yes tar; \
    apt-get autoremove; \
    apt-get clean all

COPY mongo/init.sh /docker-entrypoint-initdb.d/init.sh
COPY mongo/demo.tar.bz2 /data/demo.tar.bz2

RUN [ -d /data/demo ] \
    && tar --extract --overwrite --remove-files --force-local --file=/data/demo.tar.bz2 --verbose --directory=/data/ \
    && rm -rf /data/demo.tar.bz2
