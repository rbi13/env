## Function list
# Docker
#
## TODO 
##

# docker run 
#	-d:detach(background) 
#	-i:interactive(kee STDIN open) 
#	-t:throw away container  
#

alias dk='docker'
alias di='dk images'
alias dc='dk ps -a'
alias dl='dk logs'
alias dstats='dk stats'
alias dastats='dk stats --all'
alias dtop='dk top'
alias dport='dk ports'
alias ddiff='dk diff'
alias du='dk pull'
alias dp='dk push'
alias dcm='dk commit'
alias dsearch='dk search'
alias dr='dk run'
alias drc='dr --rm'
alias drd='dr -d'
alias dri='dr -it'
alias da='dk attach'
alias ds='dk stats'
alias dst='dk stop'
alias dsta='dk stop $(dk ps -a -q)'
alias drst='dk restart'
alias dkk='dk kill'
alias drmc='dk rm'
alias drmca='dk rm $(dk ps -a -q)'
alias drmi='dk rmi'
alias de='dk exec'
alias db='dk build'
alias dip='dk inspect'
alias dcu='docker-compose up'

# run and attach in one command
dra() { da $(dri -d "$@") ;}
# not working
#drca() { id=$(dra "$@"); wait $id; drmc id; }

# import/export
diexport(){
	echo "${$1/\\//.}"
	#docker save -o "${$1/\//.}" $1
}

ins-docker(){
	version='latest'
	# download and install docker into '/usr/bin'
	wget "https://get.docker.com/builds/Linux/x86_64/docker-${version}.tgz"
	tar -xvzf docker-latest.tgz
	sudo mv docker/* /usr/bin/
	# create docker group
	sudo groupadd docker
	sudo usermod -aG docker $USER
	rmdir docker-latest.tgz
	# add systemd scripts for docker deamon
	sudo wget 'https://raw.githubusercontent.com/docker/docker/master/contrib/init/systemd/docker.service' -P /etc/systemd/system
	sudo wget 'https://raw.githubusercontent.com/docker/docker/master/contrib/init/systemd/docker.socket' -P /etc/systemd/system
	sudo systemctl enable docker
	# install docker-compose
	curl -L "https://github.com/docker/compose/releases/download/1.8.0/docker-compose-`uname -s`-`uname -m`" > docker-compose
	sudo mv docker-compose /usr/local/bin/docker-compose
	sudo chmod +x /usr/local/bin/docker-compose
	# verify
	docker --version
	docker-compose --version
}


# cp to rc if behind a proxy for higher-level tools like docker compose
#proxy_ip="10.254.12.71:8000"
#proxy_ip="192.168.174.250:8000"
#build_proxy_args="--build-arg http_proxy=http://$proxy_ip --build-arg https_proxy=https://$proxy_ip --build-arg HTTP_PROXY=http://$proxy_ip --build-arg HTTPS_PROXY=https://$proxy_ip"
#run_proxy_args="--env http_proxy=http://$proxy_ip --env https_proxy=https://$proxy_ip --env HTTP_PROXY=http://$proxy_ip --env HTTPS_PROXY=https://$proxy_ip"

#function docker {
#        if [[ "$1" = "build" ]]; then
#                /usr/bin/docker build $build_proxy_args "${@:2}"
#        else
#		/usr/bin/docker "${@:1}"
#        fi
#}
