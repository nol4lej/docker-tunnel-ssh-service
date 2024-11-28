#!/bin/bash

# Agregar claves públicas del host al archivo known_hosts
echo "[INFO] Recopilando y agregando claves públicas del host ($TUNNEL_AUTH_HOST) al archivo known_hosts..."
ssh-keyscan -H $TUNNEL_AUTH_HOST >> ~/.ssh/known_hosts 2>> ~/.ssh/ssh-keyscan.log

# Verificar si la operación fue exitosa
if [ $? -eq 0 ]; then
    echo "[INFO] Claves agregadas correctamente a known_hosts."
else
    echo "[ERROR] No se pudieron agregar las claves a known_hosts."
    exit 1
fi

sleep 1

echo "[INFO] Estableciendo conexión de túnel SSH..."
ssh -i /root/.ssh/private_key.pem \
    -g \
    -N \
    -L $TUNNEL_SHARED_PORT:$TUNNEL_DB_HOST:$TUNNEL_DB_PORT \
    $TUNNEL_AUTH_USER@$TUNNEL_AUTH_HOST \
    -p $TUNNEL_AUTH_PORT
