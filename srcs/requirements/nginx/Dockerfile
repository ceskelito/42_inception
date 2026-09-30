FROM debian:bookworm

RUN apt-get -y update && \
	apt-get install -y --no-install-recommends \
	gettext-base \
	nginx

COPY tools/docker-entrypoint.sh /
COPY tools/envsubst-on-templates.sh /docker-entrypoint.d/

EXPOSE 443

ENTRYPOINT ["/docker-entrypoint.sh"]

CMD ["nginx", "-g", "daemon off;"]
