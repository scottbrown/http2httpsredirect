FROM alpine:3.4
MAINTAINER Infrastructure @ Unbounce

RUN apk add --update nginx
COPY nginx.conf /etc/nginx/nginx.conf
RUN mkdir -p /run/nginx

EXPOSE 80

CMD ["nginx"]

