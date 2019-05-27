FROM alpine:3.8
MAINTAINER Scott Brown

RUN apk add --update nginx nginx-mod-http-headers-more
COPY nginx.conf /etc/nginx/nginx.conf
RUN mkdir -p /run/nginx

EXPOSE 80

CMD ["nginx"]

