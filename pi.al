#!/bin/sh

rpitorrent(){
  url='https://downloads.raspberrypi.org/raspios_lite_armhf_latest.torrent'
  path=~/Downloads/torrent/w
  curl -Ls ${url} > ${path}/raspios.torrent
}

rpiheadless(){
  usr=`whoami`
  path=/media/${usr}/boot
  touch ${path}/ssh
}

rpidocker(){
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

spi(){ ssh pi@$1.local ;}

rpiinit(){
  newname=$1
  oldname=`hostname`
	apt install -y git curl
  url='https://raw.githubusercontent.com/rbi13/env/master/install.sh'
	curl ${url} | sh && source ~/.bashrc
  sudo sed -i "s/${oldname}/${newname}/g" /etc/hosts
  sudo hostnamectl set-hostname ${newname}
  sudo reboot
}

rpibootstrap(){
  newname=$1
  host=pi@raspberrypi.local
  trustme ${host}
  ssh ${host} "$(typeset -f rpiinit); rpiinit ${newname}"
}
