FROM alpine:3.6
MAINTAINER Infrastructure @ Unbounce

RUN apk add --update nginx nginx-mod-http-headers-more
COPY nginx.conf /etc/nginx/nginx.conf
RUN mkdir -p /run/nginx

EXPOSE 80

CMD ["nginx"]

