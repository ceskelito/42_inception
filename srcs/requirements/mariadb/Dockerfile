FROM debian:bookworm

RUN apt-get -y update && \
        apt-get install -y --no-install-recommends \
        mariadb-server

COPY tools/docker-entrypoint.sh /usr/local/bin/
COPY conf/99-my.cnf /etc/mysql/mariadb.conf.d/

#EXPOSE 3306

ENTRYPOINT ["docker-entrypoint.sh"]

CMD ["mariadbd"] 
#, "-u", "mysql"]
