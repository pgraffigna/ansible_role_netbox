#!/bin/bash
#script para instalar netbox

#Colores
greenColor="\e[0;32m\033[1m"
redColor="\e[0;31m\033[1m"
yellowColor="\e[0;33m\033[1m"
endColor="\033[0m\e[0m"

echo -e "${yellowColor}chequeando las dependencias ${endColor}"

if ! [ -x "$(command -v git)" ]; then 
  	echo -e "${yellowColor}git no esta instalado..instalando\n ${endColor}" && sudo apt-get install -y git -qq 
else	
  	echo -e "${greenColor}el programa existe..seguimos ${endColor}" 
fi

echo -e "${yellowColor}clonando el repo ${endColor}"
git clone -b release https://github.com/netbox-community/netbox-docker.git && cd netbox-docker

echo -e "${yellowColor}creando el docker-compose para netbox ${endColor}"
tee docker-compose.override.yml <<EOF
version: '3.4'
services:
  netbox:
    ports:
      - 8000:8080
EOF

echo -e "${yellowColor}descargando la imagen via docker ${endColor}"
docker-compose pull

echo -e "${yellowColor}levantando el servicio ${endColor}"
docker-compose up -d
