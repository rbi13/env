#!/bin/sh

rpiheadless(){
  usr=`whoami`
  path=/media/${usr}/boot
  touch ${path}/ssh
}

rpi-idocker(){
  sudo apt install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg2 \
    software-properties-common\
    python3-pip libffi-dev
  curl -sSL https://get.docker.com | sh
  pip3 install docker-compose
  docker-compose --version
}
