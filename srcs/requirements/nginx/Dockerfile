FROM debian:bookworm

RUN apt-get -y update && \
	apt-get install -y --no-install-recommends \
	nginx

CMD ["nginx", "-g", "daemon off;"]
