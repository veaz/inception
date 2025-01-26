FROM alpine:3.21.2

RUN apk update && apk add --no-cache nginx openssl

# Crear directorio para certificados SSL primero
RUN mkdir -p /etc/nginx/ssl

# Generar certificados SSL autofirmados después de crear el directorio
RUN openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
    -keyout /etc/nginx/ssl/server.key \
    -out /etc/nginx/ssl/server.crt \
    -subj "/C=ES/ST=Madrid/L=Madrid/O=42/OU=42/CN=localhost"

# Copiar la configuración de nginx
COPY conf/nginx.conf /etc/nginx/nginx.conf

EXPOSE 443

# Usar ENTRYPOINT ?
CMD ["nginx", "-g", "daemon off;"]
