#!/bin/bash
#
# rpi stuff
#
# df -h
# umount
# enable ssh
# touch /media/$USER/boot/ssh

# write to sd card: img disk
img-write() { sudo dd bs=4M status=progress if="$1" of="$2"; sudo sync ;}
# clone image from card: img disk
img-clone() { sudo dd bs=4M status=progress if="$2" of="$1"; sudo sync ;}

# pi first-boot
pi-init(){
	line='sudo apt-get update -y && sudo apt-get upgrade -y && sudo apt-get install git -y'
	echo $line | cbcopy
  	echo $line
}

# installers
# docker: 'curl -sSL https://get.docker.com | sh'
# k8s: (depends on docker)
#  git clone https://github.com/kubernetes/kube-deploy && cd kube-deploy/docker-multinode && sudo ./master.sh
# or
# git clone https://github.com/kubernetes/kube-deploy && cd kube-deploy/docker-multinode && export MASTER_IP=${SOME_IP} && sudo ./worker.sh
