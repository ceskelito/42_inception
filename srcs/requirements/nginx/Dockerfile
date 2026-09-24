FROM debian:bookworm

ARG user=defaultuser
ARG base_domain=defaultuser.42.fr

ARG certs_path=/etc/nginx/certs
ARG ssl_cert=${certs_path}/${base_domain}.crt
ARG ssl_cert_key=${certs_path}/${base_domain}.key

RUN apt-get -y update && \
	apt-get install -y --no-install-recommends \
	nginx

CMD ["nginx", "-g", "daemon off;"]
