#!/usr/bin/env bash

# variables
GIT_URL="https://github.com/netbox-community/netbox-docker.git"

#Colores
VERDE="\e[0;32m\033[1m"
ROJO="\e[0;31m\033[1m"
AMARILLO="\e[0;33m\033[1m"
FIN="\033[0m\e[0m"

echo -e "${AMARILLO}[NETBOX] Instalando dependencias ${FIN}"
sudo apt update && sudo apt-get install -y git docker-compose

echo -e "${AMARILLO}[NETBOX] Clonando el repo ${FIN}"
git clone -b release ${GIT_URL} && cd netbox-docker

echo -e "${AMARILLO}[NETBOX] Aplicando fix para docker-compose netbox [ eliminando los healthchecks - solo testing env ] ${FIN}"
tee docker-compose.yml <<EOF
version: '3'

services:
  netbox: &netbox
    image: netboxcommunity/netbox:${VERSION-v3.4-2.4.0}
    depends_on:
    - postgres
    - redis
    - redis-cache
    env_file: env/netbox.env
    user: 'unit:root'
    volumes:
    - ./configuration:/etc/netbox/config:z,ro
    - ./reports:/etc/netbox/reports:z,ro
    - ./scripts:/etc/netbox/scripts:z,ro
    - netbox-media-files:/opt/netbox/netbox/media:z

  postgres:
    image: postgres:15-alpine
    env_file: env/postgres.env
    volumes:
    - netbox-postgres-data:/var/lib/postgresql/data

  redis:
    image: redis:7-alpine
    command:
    - sh
    - -c # this is to evaluate the $REDIS_PASSWORD from the env
    - redis-server --appendonly yes --requirepass H733Kdjndks81
    volumes:
    - netbox-redis-data:/data

  redis-cache:
    image: redis:7-alpine
    command:
    - sh
    - -c # this is to evaluate the $REDIS_PASSWORD from the env
    - redis-server --requirepass t4Ph722qJ5QHeQ1qfu36
    volumes:
    - netbox-redis-cache-data:/data

volumes:
  netbox-media-files:
    driver: local
  netbox-postgres-data:
    driver: local
  netbox-redis-data:
    driver: local
  netbox-redis-cache-data:
    driver: local
EOF

tee docker-compose.override.yml <<EOF
version: '3'
services:
  netbox:
    ports:
      - 8000:8080
EOF

echo -e "${AMARILLO}[NETBOX] Descargando la imagen de netbox ${FIN}"
docker-compose pull &>/dev/null

echo -e "${AMARILLO}[NETBOX] Levantando el servicio ${FIN}"
docker-compose up -d

echo -e "${VERDE}[NETBOX] Acceder via navegador al servicio..darle 30 segundos para que levanten los servicios ${FIN}"
