FROM debian:bookworm

RUN set -e; \
	apt-get -y update; \
	apt-get install -y --no-install-recommends \
		gettext-base \
		nginx \
	; \
	rm -rf /var/lib/apt/lists*


COPY --chmod=550 tools/docker-entrypoint.sh /
COPY --chmod=550 tools/20-envsubst-on-templates.sh /docker-entrypoint.d/
COPY --chmod=440 templates/wordpress.conf.template /etc/nginx/templates/

EXPOSE 443

ENTRYPOINT ["/docker-entrypoint.sh"]

CMD ["nginx", "-g", "daemon off;"]
