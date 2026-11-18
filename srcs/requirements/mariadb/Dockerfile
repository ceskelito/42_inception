FROM debian:bookworm

RUN	set -e; \
	apt-get -y update; \
	apt-get install -y --no-install-recommends \
		mariadb-server \
	; \
	rm -rf /var/lib/apt/lists/*; \
	\
	mkdir -p /run/mysqld; \
	chown mysql:mysql /run/mysqld

COPY --chmod=550 tools/docker-entrypoint.sh /
COPY --chmod=440 conf/99-my.cnf /etc/mysql/mariadb.conf.d/

EXPOSE 3306

ENTRYPOINT ["/docker-entrypoint.sh"]

# User mysql set as default in ./conf/99-my.cnf
CMD ["mariadbd"]
