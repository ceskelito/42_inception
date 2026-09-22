FROM debian:bookworm

RUN apt-get -y update && \
	apt-get -y install \
	nginx \
	openssl

RUN openssl req \
	-x509 \
	-newkey rsa:2048 \
	-keyout rceschel.key \
	-out rceschel.crt \
	-days 365 \
	-nodes \
	-addext "subjectAltName=DNS:rceschel.42.fr, DNS:www.rceschel.42.fr" \
	-addext "basicConstraints=critical,CA:FALSE" \
	-addext "extendedKeyUsage=serverAuth" \
	-subj "/C=IT/ST=Rome/L=Rome/O=42Roma/OU=rceschel/CN=rceschel/"
	
COPY conf/rceschel.conf /etc/nginx/conf.d/rceschel.conf

CMD ["tail", "-f", "/dev/null"]
#CMD ["nginx", "-g", "daemon off;"]
