FROM alpine:3.14

RUN apk update && apk nginx openssl

COPY conf/nginx.conf /etc/nginx/nginx.conf

EXPOSE 443

CMD ["nginx", "-g", "daemon off;"]
