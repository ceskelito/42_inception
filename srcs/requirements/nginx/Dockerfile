FROM debian:bookworm

RUN apt-get -y update && apt-get -y install nginx

COPY default.conf /etc/nginx/conf.d/default.conf

CMD ["nginx", "-g", "daemon off;"]
