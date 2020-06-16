#!/bin/sh

rpiheadless(){
  usr=`whoami`
  path=/media/${usr}/boot
  touch ${path}/ssh
}

rpi-i-docker(){
  sudo apt install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg2 \
    software-properties-common\
    python3-pip libffi-dev
  i-docker
  pip3 install docker-compose
  docker-compose --version
}
