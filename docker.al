#!/bin/sh
## Function list
# Docker
#
## TODO
##
# ddl=grep docker /var/log/messages
# user --user=$(id -u)

alias dk='docker'
alias dr='dk run'

# run single command
alias drc='dr --rm'
alias drp='drc -d -v `pwd`:"/`basename $(pwd)`" -w "/`basename $(pwd)`"'
alias drph='drp -v $HOME:"/root/"'

# run as shell
alias dri='drc -it'
alias drip='dri -v `pwd`:"/`basename $(pwd)`" -w "/`basename $(pwd)`"'
alias dripf='dri -v `pwd`:`pwd` -w `pwd`'
dre(){ drc -it --entrypoint '/bin/sh' ${@:1} ;}
drep(){ drip -it --entrypoint '/bin/sh' ${@:1} ;}
drb(){ dri ${@:1} /bin/bash ;}
drbp(){ drip ${@:1} /bin/bash ;}
drbf(){ dripf ${@:1} /bin/bash ;}
drbph(){ drip -v ${HOME}:/root ${@:1} /bin/bash ;}
dhb(){ drbph ${@:1} ;}
dhd(){ drph ${@:1} ;}
dh(){ drip -v ${HOME}:/root ${@:1} ;}
dhe(){
	if [[ ${@: -1} == "@" ]]; then
		dhb ${@:1:($#-2)}
	elif [[ ${@: -1} == "@@" ]]; then
		dh --entrypoint '/bin/sh' ${@:1:($#-2)}
	else
		dh ${@:1}
	fi
}

# exec
drd(){ dr -d ${@:1} ;}
drcd(){ drc -d ${@:1} ;}
alias da='dk attach'
alias dst='dk stop'
alias dsta='dk stop $(dk ps -a -q)'
alias drst='dk restart'
alias dkk='dk kill'
dx(){
	# [ -z "$1" ] && args=`dc -q` || args=${@:1}
	dk exec -it `dc -q` ${@:1}
}
dxb(){ dx /bin/bash ;}
dcd(){ docker-compose ${@:1} down ;}
dcb(){ docker-compose build ${@:1} ;}
dcr(){ docker-compose run --rm ${@:1} ;}
dcrn(){ docker-compose run --rm -T --service-ports ${@:1} ;}
dcst(){ docker-compose stop ${@:1} ;}
dcrb(){ docker-compose run --rm ${@:1} /bin/bash ;}
dcrbn(){ dcrn ${@:1} /bin/bash ;}
dcrs(){ docker-compose restart ${@:1} ;}
dck(){ docker-compose kill ${@:1} && docker-compose rm -f ${@:1} ;}
dcl(){ docker-compose logs -f ${@:1} ;}
dcu(){ docker-compose ${@:1} up ;}
dcud(){ docker-compose ${@:1} up -d ;}
dcprm(){ docker-compose rm ${@:1} ;}
dcx(){ docker-compose exec ${@:1} ;}
dcxb(){ docker-compose exec ${@:1} /bin/bash ;}
dcs(){ docker-compose scale ${@:1} ;}
dcul(){ dcd && dcud && dcl ;}
# building
alias dt='dk tag'
alias dhub='dk search'
alias dp='dk push'
alias dku='dk pull'
alias dcm='dk commit'
db(){
	if [ -z $2 ]; then
		dk build -t $1 .
	elif [ -z $3 ]; then
		dk build -t $1 -f $2 .
	else
		dk build -t ${@:1}
	fi
}

# cleanup
drmc(){ dk rm ${@:1} ;}
alias drmca='dk rm $(dk ps -a -q)'
alias drmi='dk rmi'
#todo  docker rmi -f $(docker images -q -a -f dangling=true)
dic(){ drmi $(di | grep '<none>' | awk '{print $3}') ;}

# copy
dcp(){
	id=$1
	src=$2
	dst=$3
	[ -z "$2" ] && { echo 'usage: dcpi container_id src dest'; return;}
	[ -z "${dst}" ] && dst=`basename $src`
	docker cp ${id}:${src} ${dst}
}
dcpi(){
	img=$1
	src=$2
	dst=$3
	[ -z "$2" ] && { echo 'usage: dcpi image src dest'; return;}
	[ -z "${dst}" ] && dst=`basename $src`
	id=$(docker create ${img})
	docker cp -L ${id}:${src} ${dst}
	docker rm ${id}
}

# volumes
alias dv='dk volume ls'
alias dvd='dv -f dangling=true'
alias dvc='dk volume create --name'
alias drmv='dk volume rm'
alias drmva='drmv $(dv -q)'
alias drmvd='drmv $(dvd -q)'

# monitoring
alias di='dk images'
alias dc='dk ps -a'
alias dl='dk logs'
alias dlf='dk logs -f'
alias dki='dk inspect'
alias ds='dk stats'
alias dstats='dk stats --all'
alias dtop='dk top'
alias dport='dk ports'
alias ddiff='dk diff'

# networking
alias dn='dk network ls'
alias drmn='dk network rm'
alias drmna='drmn `dn -q`'
alias dni='dk network inspect'

# machine
alias dm='docker-machine'
alias dmc='dm create'
dmcg(){
	host=$1
	[ -z "$2" ] && user="root" || user=$2
	[ -z "$3" ] && key="~/.ssh/id_rsa" || key=$3
	dmc --driver generic \
	--generic-ssh-user ${user} \
	--generic-ip-address ${host} \
	--generic-ssh-key ${key} \
	${@:3}
}

# registry
alias dsearch='dk search'
# TODO
#dtsearch(){ curl "https://hub.docker.com/v2/$1/tags/list" }
# docker hub
hubsearch(){
  open "https://hub.docker.com/search/?q=$1&isAutomated=0&isOfficial=0&page=1&pullCount=0&starCount=0"
}
hubtags(){
  [[ "$1" == *"/"* ]] && repo=$1 || repo="library/$1"
  open "https://hub.docker.com/r/${repo}/tags/"
}

# import/export
diexport(){
	echo "${$1/\\//.}"
	#docker save -o "${$1/\//.}" $1
}

#TODO: alias for image removal from registry
#curl -u<user:password> -X DELETE "<Artifactory URL>/<Docker v2 repository name>/<namespace>:<tag>"

i-docker(){
	url='https://github.com/docker/docker-ce/releases/latest'
	tag=`curl -Ls -o /dev/null -w %{url_effective} ${url}`
	tag=${tag##*/}
	version=${tag:1}
	arch=`uname -m`
	[ ${arch} = 'armv7l' ] && arch='armhf'
	zipname=docker-${version}.tgz
	url='https://download.docker.com/linux/static/stable'
	curl -Ls ${url}/${arch}/${zipname} > ${zipname}
	tar -xvzf ${zipname}
	sudo rsync docker/* /usr/bin/
	# create docker group
	sudo groupadd docker
	sudo usermod -aG docker $USER
	rm -rf ${zipname} docker/
	# add systemd scripts for docker deamon
	url='https://raw.githubusercontent.com/docker/docker/master/contrib/init/systemd/'
	path=/etc/systemd/system
	curl -Ls -O ${url}/docker.service
	curl -Ls -O ${url}/docker.socket
	sudo mv docker.service docker.socket ${path}/
	sudo systemctl enable docker
	sudo systemctl start docker
	[ ${arch} != 'armhf' ] && i-docker-compose
	docker --version
}

i-docker-compose(){
	url='https://github.com/docker/compose/releases/latest'
	tag=`curl -Ls -o /dev/null -w %{url_effective} ${url}`
	version=${tag##*/}
	osname=`uname -s`
	arch=`uname -m`
	exname=docker-compose-${osname}-${arch}
	url='https://github.com/docker/compose/releases/download'
	path=/usr/bin
	sudo curl -Ls ${url}/${version}/${exname} > docker-compose
	sudo mv docker-compose ${path}/docker-compose
	sudo chmod +x ${path}/docker-compose
	docker-compose --version
}


# cp to rc if behind a proxy for higher-level tools like docker compose
# proxy_ip="<PROXY>:<PORT>"
# build_proxy_args="--build-arg http_proxy=http://$proxy_ip \
# 	--build-arg https_proxy=https://$proxy_ip \
# 	--build-arg HTTP_PROXY=http://$proxy_ip \
# 	--build-arg HTTPS_PROXY=https://$proxy_ip"
# function docker {
# 	if [[ "$1" = "build" ]]; then
# 		command docker build $build_proxy_args "${@:2}"
# 	else
# 		command docker "${@:1}"
# 	fi
# }

# start script for init.d/systemd container apps
# (){
#   name=$1
#   empty=`docker ps -a -f "name=${name}" | grep -w ${name}`
#   if [[ -z "${empty}" ]]; then
#     echo "docker run --name ${name} ..."
#   else
#     echo "docker start ..."
#   fi
# }
