# Docker SSH Tunnel Service

Este repositorio proporciona un servicio Docker diseñado para establecer túneles SSH utilizando una clave privada (.pem), facilitando conexiones seguras a servidores de bases de datos. Es ideal para entornos de desarrollo o pruebas donde se requiere acceder a bases de datos protegidas mediante SSH.

**Caso de uso común**:

Integrar este servicio en una red Docker de desarrollo, permitiendo conexiones seguras a servidores remotos desde múltiples contenedores dentro del entorno. Se incluyen ejemplos de configuración para conectarse a bases de datos MySQL y PostgreSQL alojadas en el mismo servidor.

---

## Características

- Configuración de túneles SSH para múltiples servidores de bases de datos.
- Reutilización del mismo `Dockerfile` y script `tunnel.sh` para diferentes servicios.
- Ejemplo preconfigurado para conexiones a **MySQL** y **PostgreSQL** de un mismo servidor.

---

## Requisitos previos

1. **Docker** instalado en el sistema.
2. Una clave privada `.pem` válida para la conexión SSH.
3. Variables de entorno configuradas para definir las conexiones.

---

## Configuración inicial

```bash
git clone https://github.com/nol4lej/docker-tunnel-ssh-service
cd docker-tunnel-ssh-service
```

### Ajustar el contexto del build

Asegúrate de que las rutas y configuración en el archivo `docker-compose.yml` sean correctas:

1. **Ruta del Dockerfile**: Verifica que el context y dockerfile apunten al directorio correcto.
```bash
build:
  context: .
  dockerfile: Dockerfile
```

2. **Ruta del script** `tunnel.sh`: Ajusta la ruta en los volúmenes si es necesario:
```bash
volumes:
  - ./tunnel.sh:/tunnel.sh
```

3. **Red Docker**: Asegúrate de que los servicios se encuentren dentro de la misma red de tu proyecto:
```bash
networks:
    - test-network
```

### Variables de entorno

En el archivo `.env` de tu proyecto agrega:

```bash
# Clave privada SSH
PRIVATE_KEY_PATH=/ruta/de/key.pem

# Configuración del túnel para MySQL
TUNNEL_MYSQL_DB_HOST=db-mysql.amazonaws.com
TUNNEL_MYSQL_DB_PORT=3306

# Configuración del túnel para PostgreSQL
TUNNEL_PGSQL_DB_HOST=db-pgsql.amazonaws.com
TUNNEL_PGSQL_DB_PORT=5432

# Configuración SSH
TUNNEL_AUTH_USER=user
TUNNEL_AUTH_HOST=64.233.186.113
TUNNEL_AUTH_PORT=22

# Puerto compartido por el túnel
TUNNEL_SHARED_PORT=5433
```

---

# Crear conexiones para nuevos servidores

De esta forma, es posible establecer múltiples túneles para conectar con diferentes servidores y acceder a diversas bases de datos de manera simultánea.

1. Duplica la configuración de uno de los servicios en el archivo `docker-compose.yml`.

2. Renombra las variables de entorno asociadas al nuevo servidor.

```bash
tunnel-new:
    build:
        context: .
        dockerfile: Dockerfile
        args:
            PRIVATE_KEY_PATH: ${NEW_PRIVATE_KEY_PATH}
    container_name: tunnel-new
    volumes:
        - ${NEW-PRIVATE_KEY_PATH}:/root/.ssh/private_key.pem
        - ./tunnel.sh:/tunnel.sh
    environment:
        PRIVATE_KEY_PATH: ${NEW_PRIVATE_KEY_PATH}
        TUNNEL_DB_HOST: ${NEW_TUNNEL_DB_HOST}
        TUNNEL_DB_PORT: ${NEW_TUNNEL_DB_PORT}
        TUNNEL_AUTH_USER: ${NEW_TUNNEL_AUTH_USER}
        TUNNEL_AUTH_HOST: ${NEW_TUNNEL_AUTH_HOST}
        TUNNEL_AUTH_PORT: ${NEW_TUNNEL_AUTH_PORT}
        TUNNEL_SHARED_PORT: ${NEW_TUNNEL_SHARED_PORT}
    networks:
        - test-network
    command: [ "sh", "/tunnel.sh" ]
```

3. Añade las nuevas variables al archivo `.env`.

```bash
NEW_PRIVATE_KEY_PATH=/ruta/de/new_key.pem
NEW_TUNNEL_DB_HOST=db-mysql.amazonaws.com
NEW_TUNNEL_DB_PORT=3306
NEW_TUNNEL_AUTH_USER=user
NEW_TUNNEL_AUTH_HOST=64.233.186.113
NEW_TUNNEL_AUTH_PORT=22
NEW_TUNNEL_SHARED_PORT=5433
```

# Consideraciones adicionales

1. **Permisos de la clave privada**: La clave privada debe tener permisos adecuados:
```bash
chmod 600 /ruta/de/key.pem
```