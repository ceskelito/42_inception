FROM debian:bookworm

RUN apt update && apt install -y \
	gpg \
	curl

COPY --chmod=770 install_wp_cli.sh /docker-entrypoint.sh

ENTRYPOINT ["/docker-entrypoint.sh"]
