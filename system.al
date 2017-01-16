#!/bin/sh
## Function list
# System calls and information
#
## TODO
##
# list-dns(){ nmcli device show <interfacename> | grep IP4.DNS ;}
# file-count='ls -l | wc -l'
# uuid='uuidgen' OR 'cat /proc/sys/kernel/random/uuid'
#
# global proxy config (curl, wget, etc.)
#  - curlrc: proxy=<proxy_host>:<proxy_port>
#	 - wgetrc: use_proxy=yes \n http_proxy=127.0.0.1:8080
#  - yum: proxy=http://mycache.mydomain.com:3128

alias ctl='sudo systemctl'
alias restartctl='ctl daemon-reload'
alias kernel-version='uname -mrs'
alias distro-info='cat /etc/*-release'
alias distro-base='lsb_release -a'
alias poweroff='sudo shutdown -h now'
alias disk='du -hd'

ipaddr(){
	[[ -z "$1" ]] && iface='eth0' || iface=$1
	echo $(ip addr show ${iface} | grep -Eo '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}' | head -1)
}

alias users='cut -d: -f1 /etc/passwd'
alias groupuser='sudo usermod user -a -G' # <group> <user>
function groupshow { grep $1 /etc/group ;}

# Define a timestamp function
timestamp() { date +%s%3N ;}
timestamp64() { timestamp | base64 ;}

# clipboard
alias cbcopy='xclip -selection c'
alias cbpaste='xclip -selection clipboard -o'
clip() { [[ -f "$1" ]] && cat $1 | cbcopy || exec "${@:1}" | cbcopy ;}

# ssh
alias skeys='ls -al ~/.ssh'
# generate ssh keys e.g. sgen <account@email.com>
alias sgen='ssh-keygen -t rsa -b 4096 -C'
scat() {
	[[ -z "$1" ]] && key=~/.ssh/id_rsa.pub || key=~/.ssh/$1.pub
	cat $key | cbcopy
	cat $key
}
# TODO: add command for public key distribution
# ssh-keygen -t rsa

# adds ssh pub key to specified host server
trustme(){
	host=$1
	cat ~/.ssh/id_rsa.pub | ssh ${host} 'mkdir -p .ssh && \
	cat >> .ssh/authorized_keys && \
	chmod 700 .ssh && \
	chmod 640 .ssh/authorized_keys'
}

skeyscan(){
	host=$1
	ssh-keyscan -H ${host} >> ~/.ssh/known_hosts
}

# system-detection
ismac(){ [ "$(uname)" == "Darwin" ] ;}
#islinux(){ [ "$(expr substr $(uname -s) 1 5)" == "Linux" ] ;}
getkernel(){ ismac && echo 'darwin' || echo 'linux' ;}

# overrides 'open' to make it cross platform
open(){ ismac && command open ${@:1} || xdg-open ${@:1} ;}

# package managers
alias sag='sudo apt-get'

# networking
alias ports='netstat -plnt'

# TODO: make network .al
#TODO: create functions for different net-iface managers
## dhcpcd
#interface eth0
#  static ip_address=192.168.0.180/24
#  static routers=192.168.0.1
#  static domain_name_servers=192.168.0.1

wallpaper(){
	if [ -z $1 ]; then
		gsettings get org.gnome.desktop.background picture-uri
	else
		[ "$1" == "-r" ] && image="$HOME/Pictures/$(ls ~/Pictures | shuf -n 1)" || image=$1
		image=$(realpath $image)
		gsettings set org.gnome.desktop.background picture-uri "file://${image}"
	fi
}
