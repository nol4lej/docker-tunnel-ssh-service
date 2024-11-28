FROM alpine:latest

RUN apk add --no-cache \
    openssh-client \
    bash \
    curl

RUN mkdir -p /root/.ssh

# Comando que se ejecutará al iniciar el contenedor
CMD ["sh", "/tunnel.sh"]